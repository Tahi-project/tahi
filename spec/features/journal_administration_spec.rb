require 'rails_helper'

feature "Journal Administration", js: true do
  let(:user) { create :user, :site_admin }
  let!(:journal) { create :journal, :with_roles_and_permissions }
  let!(:another_journal) { create :journal, :with_roles_and_permissions }

  before do
    login_as(user, scope: :user)
    visit "/"
  end

  let(:admin_page) { AdminDashboardPage.visit }
  let(:journal_page) { admin_page.visit_journal(journal) }
  let(:flow_page) { journal_page.add_flow }

  describe "journal listing" do
    context "when the user is a site admin" do
      let(:user) { create :user, :site_admin }

      scenario "shows all journals" do
        journal_names = [journal, another_journal].map(&:name)
        expect(admin_page).to have_journal_names(*journal_names)
      end
    end

    context "when the user is a journal admin" do
      let(:user) { create :user }
      before { assign_journal_role(journal, user, :admin) }

      scenario "shows assigned journal" do
        # refresh page since we've assigned the journal role
        visit "/"
        expect(admin_page).to have_journal_names(journal.name)
      end
    end

    context "when the user is not a site admin or journal admin" do
      let(:user) { create :user }

      scenario "redirects to dashboard" do
        visit AdminDashboardPage.path
        expect(page).to have_no_content(AdminDashboardPage.admin_section)
      end
    end
  end

  describe "Visiting a journal" do
    scenario "shows manuscript manager templates" do
      mmt_names = journal.manuscript_manager_templates.pluck(:paper_type)
      expect(journal_page.mmt_names).to match_array(mmt_names)
    end

    scenario "editing a MMT" do
      mmt = journal.manuscript_manager_templates.first
      mmt_page = journal_page.visit_mmt(mmt)
      expect(mmt_page).to have_paper_type(mmt.paper_type)
    end

    describe "deleting a MMT" do
      let!(:mmt_to_delete) { FactoryGirl.create(:manuscript_manager_template, journal: journal) }

      it "deletes MMT" do
        journal_page.delete_mmt(mmt_to_delete)
        expect(journal_page).to have_no_mmt_name(mmt_to_delete.paper_type)
      end
    end

    describe "on a Journal's Flow Manager" do

      describe do
        before { flow_page }

        it "show Journal name as text" do
          expect(page.find(".column-title-wrapper")).to have_content journal.name
        end
      end

      describe do
        it "show Journal logo" do
          using_wait_time 5 do
            with_aws_cassette(:yeti_image) do
              journal.update_attributes(logo: File.open("spec/fixtures/yeti.jpg"))
              visit "/admin/journals/1/old_roles/1/flow_manager"
              find(".control-bar-link-icon").click
              expect(page.find(".column-title-wrapper")).to have_css("img")
            end
          end
        end
      end

      context "editing a flow title" do
        before { flow_page }

        it "reveals 'cancel / save' buttons" do
          expect(page).to have_content 'Up for grabs'
          find('h2.column-title').click()
          expect(page).to have_button('cancel')
          expect(page).to have_button('Save')
        end
      end

      context "saving an edited flow" do
        before { flow_page }

        it "removes 'cancel / save' buttons" do
          expect(page).to have_content 'Up for grabs'
          find('h2.column-title').click()
          find('button.column-header-update-save').click()
          expect(page).not_to have_button('cancel')
          expect(page).not_to have_button('Save')
        end
      end

    end

  end
end
