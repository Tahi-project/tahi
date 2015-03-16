require 'rails_helper'
class TestTask < Task
  include TaskTypeRegistration
  include Invitable

  register_task default_title: "Test Task", default_role: "user"

  def invitation_invited(_invitation)
    "invited"
  end

  def invitation_accepted(_invitation)
    "accepted"
  end
end

describe FilteredUsersController do
  let(:user) { create :user }
  let(:journal) { FactoryGirl.create(:journal) }
  let(:role) { FactoryGirl.create(:role, :reviewer, journal: journal) }
  let(:paper) { FactoryGirl.create(:paper, journal: journal) }

  before do
    assign_journal_role(journal, user, :reviewer)
    sign_in(user)
  end

  describe "#reviewers /filtered_users/reviewers/:paper_id" do
    context "when a user has a pending invitation" do
      let!(:paper) { FactoryGirl.create(:paper, journal: journal) }
      let(:phase) { paper.phases.create! }
      let(:task) do
        phase.tasks.create(type: "TestTask",
                           title: "Test",
                           role: "reviewer").extend Invitable
      end
      let(:invitation) { create :invitation, task: task, invitee: user }

      before do
        invitation.invite!
        # invitation.accept!
      end

      it "does not send the user" do
        get :reviewers, paper_id: paper.id, format: :json
        expect(res_body["filtered_users"]).to be_empty
      end
    end

    context "when a user does not have a pending invitation" do
      context "when the user is already a reviewer" do
        before { make_user_paper_reviewer(user, paper) }
        it "does not send the user" do
          get :reviewers, paper_id: paper.id, format: :json
          expect(res_body["filtered_users"]).to be_empty
        end
      end

      it "sends the user" do
        get :reviewers, paper_id: paper.id, format: :json
        expect(res_body["filtered_users"].count).to eq 1
        expect(res_body["filtered_users"].first["id"]).to eq user.id
        expect(res_body["filtered_users"].first["email"]).to eq user.email
      end
    end
  end
end
