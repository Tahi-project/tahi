require 'rails_helper'

feature "Event streaming", js: true, selenium: true, sidekiq: :inline! do
  let(:regular_user) { FactoryGirl.create :user }
  let!(:admin) { FactoryGirl.create :user, :site_admin }
  let!(:journal) { FactoryGirl.create :journal }
  let!(:paper) { FactoryGirl.create :paper, :with_tasks, creator: admin, journal: journal }
  let(:upload_task) { paper.tasks_for_type(TahiStandardTasks::UploadManuscriptTask).first }
  let(:text_body) { { type: "text", value: "Hi there!" } }

  before do
    login_as(admin, scope: :user)
    visit "/"
  end

  context "on the workflow page" do
    before do
      click_link(paper.title)
      click_link("Workflow")
    end

    let(:submission_phase) { paper.phases.find_by_name("Submission Data") }

    scenario "managing tasks" do
      # create
      submission_phase.tasks.create title: "Wicked Awesome Card", type: "Task", body: text_body, role: "admin"
      wait_for_ajax
      expect(page).to have_content "Wicked Awesome Card"

      # destroy
      deleted_task = submission_phase.tasks.first.destroy!
      wait_for_ajax
      expect(page).to_not have_content deleted_task.title
    end
  end

  context "on the dashboard page" do
    let!(:collaborator_paper) { FactoryGirl.create(:paper, journal: journal) }
    let!(:participant_paper) { FactoryGirl.create(:paper, journal: journal) }

    scenario "access to papers" do
      # added as a collaborator
      collaborator_paper.paper_roles.collaborators.create(user: admin)
      expect(page).to have_text(collaborator_paper.title)

      # removed as a collaborator
      collaborator_paper.paper_roles.collaborators.where(user: admin).destroy_all
      expect(page).to_not have_text(collaborator_paper.title)

      # added as a participant
      participant_paper.paper_roles.participants.create(user: admin)
      expect(page).to have_text(participant_paper.title)

      # removed as a participant
      participant_paper.paper_roles.participants.destroy_all
      expect(page).to_not have_text(participant_paper.title)
    end
  end

  context "on a task" do
    let!(:regular_user_paper) { FactoryGirl.create(:paper_with_task, task_params: { type: "TahiStandardTasks::UploadManuscriptTask" }, creator: regular_user, journal: journal) }
    let(:upload_task) { regular_user_paper.tasks.first }

    before do
      Page.new.sign_out
      login_as(regular_user, scope: :user)
      visit "/"
      upload_task.participants.destroy_all
    end

    scenario "commenter is added as a participant" do
      card = Page.view_task_overlay(regular_user_paper, upload_task)
      card.post_message 'Hello'
      using_wait_time 30 do
        expect(card).to have_participants(regular_user)
        expect(card).to have_last_comment_posted_by(regular_user)
      end

      expect(page).to have_css(".task-completed:not(:checked)")
      upload_task.completed = true
      upload_task.save
      expect(page).to have_css(".task-completed:checked")
    end

    #TODO Add test to check unread status of comment
  end
end
