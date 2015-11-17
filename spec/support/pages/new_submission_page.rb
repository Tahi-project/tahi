class NewSubmissionPage < Page
  def create_submission(short_title:, journal:, paper_type:)
    fill_in 'new-paper-title', with: short_title
    select2 journal, css: ".paper-new-journal-select"
    select2 paper_type, css: ".paper-new-paper-type-select"
    click_on 'Create'
    expect(session).to have_css('#new-paper-title')
    PaperPage.new
  end
end
