require 'rails_helper'

feature 'Reviewer filling out their research article reviewer report', js: true do
  let(:journal) { FactoryGirl.create :journal, :with_roles_and_permissions }
  let(:paper) do
    FactoryGirl.create \
      :paper_with_phases,
      :submitted_lite,
      :with_creator,
      journal: journal,
      uses_research_article_reviewer_report: true
  end
  let(:task) { FactoryGirl.create :paper_reviewer_task, :with_loaded_card, paper: paper }

  let(:paper_page) { PaperPage.new }
  let!(:reviewer) { create :user }

  let!(:inviter) { create :user }

  def create_reviewer_invitation(paper)
    paper.draft_decision.invitations << FactoryGirl.create(
      :invitation,
      :accepted,
      accepted_at: DateTime.now.utc,
      task: task,
      invitee: reviewer,
      inviter: inviter,
      decision: paper.draft_decision
    )
  end

  def create_reviewer_report_task
    ReviewerReportTaskCreator.new(
      originating_task: task,
      assignee_id: reviewer.id
    ).process
  end

  before do
    assign_reviewer_role paper, reviewer

    login_as(reviewer, scope: :user)
    visit "/"
  end

  scenario "A paper's creator cannot access the Reviewer Report" do
    create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task

    ensure_user_does_not_have_access_to_task(
      user: paper.creator,
      task: reviewer_report_task
    )
  end

  scenario 'A reviewer can fill out their own Reviewer Report, submit it, and see a readonly view of their responses' do
    create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task

    Page.view_paper paper
    t = paper_page.view_task("Review by #{reviewer.full_name}", ReviewerReportTaskOverlay)

    t.fill_in_report 'reviewer_report--competing_interests--detail' =>
      'I have no competing interests'
    t.submit_report
    t.confirm_submit_report

    expect(page).to have_selector('.answer-text',
      text: 'I have no competing interests')
  end

  scenario 'A review can see their previous rounds of review' do
    create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task

    # Revision 0
    Page.view_paper paper

    t = paper_page.view_task("Review by #{reviewer.full_name}", ReviewerReportTaskOverlay)
    t.fill_in_report 'reviewer_report--competing_interests--detail' =>
      'answer for round 0'

    t.submit_report
    t.confirm_submit_report
    # no history yet, since we only have the current round of review
    t.ensure_no_review_history

    # Revision 1
    register_paper_decision(paper, "major_revision")
    paper.tasks.find_by_title("Upload Manuscript").complete! # a reviewer can't complete this task, so this is a quick workaround
    paper.submit! paper.creator

    invitation = create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task
    reviewer_report_task.reviewer_reports
      .where(state: 'invitation_not_accepted')
      .first.accept_invitation!

    Page.view_paper paper
    t = paper_page.view_task("Review by #{reviewer.full_name}",
      ReviewerReportTaskOverlay)

    t.fill_in_report 'reviewer_report--competing_interests--detail' =>
      'answer for round 1'

    t.submit_report
    t.confirm_submit_report

    t.ensure_review_history(
      title: 'v0.0', answers: ['answer for round 0']
    )

    # Revision 2
    register_paper_decision(paper, "major_revision")
    paper.tasks.find_by_title("Upload Manuscript").complete! # a reviewer can't complete this task, so this is a quick workaround
    paper.submit! paper.creator

    create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task

    Page.view_paper paper
    t = paper_page.view_task("Review by #{reviewer.full_name}", ReviewerReportTaskOverlay)

    t.fill_in_report 'reviewer_report--competing_interests--detail' =>
      'answer for round 2'

    t.ensure_review_history(
      { title: 'v0.0', answers: ['answer for round 0'] },
      title: 'v1.0', answers: ['answer for round 1']
    )

    # Revision 3 (we won't answer, just look at previous rounds)
    register_paper_decision(paper, "major_revision")
    paper.tasks.find_by_title("Upload Manuscript").complete! # a reviewer can't complete this task, so this is a quick workaround
    paper.submit! paper.creator

    create_reviewer_invitation(paper)
    reviewer_report_task = create_reviewer_report_task

    Page.view_paper paper
    t = paper_page.view_task("Review by #{reviewer.full_name}", ReviewerReportTaskOverlay)

    t.ensure_review_history(
      { title: 'v0.0', answers: ['answer for round 0'] },
      { title: 'v1.0', answers: ['answer for round 1'] },
      title: 'v2.0', answers: ['answer for round 2']
    )
  end
end
