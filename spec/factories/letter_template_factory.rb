FactoryGirl.define do
  factory :letter_template do
    to 'author@example.com'
    subject 'Your [JOURNAL_NAME] submission'

    name 'Some Decision'
    category ''
    body <<-LETTER.strip_heredoc
              ***EDIT THIS LETTER BEFORE SENDING****\n\nDear Dr. [Last Name],\n\nSincerely,\n\n[EDITOR NAME]\n[EDITOR TITLE]\nPLOS Biology  \n
           LETTER

    trait(:reject) do
      name 'Editor Decision - Reject After Review'
      category 'reject'
      body <<-LETTER.strip_heredoc
          ***EDIT THIS LETTER BEFORE SENDING****\n\nDear Dr. [Last Name],\n\nSorry, Reject!.\n\nSincerely,\n\n[EDITOR NAME]\n[EDITOR TITLE]\nPLOS Biology  \n
       LETTER
    end

    trait(:accept) do
      name 'RA- Accept'
      category 'accept'
      body <<-LETTER.strip_heredoc
          ***EDIT THIS LETTER BEFORE SENDING****\n\nDear Dr. [Last Name],\n\ Accept!\n publish your manuscript in [JOURNAL NAME]\n\nSincerely,\n\n[EDITOR NAME]\n[EDITOR TITLE]\nPLOS Biology  \n
       LETTER
    end

    trait(:major_revision) do
      name 'Editor Decision - Major Revision'
      category 'major_revision'
      body <<-LETTER.strip_heredoc
          ***EDIT THIS LETTER BEFORE SENDING****\n\nDear Dr. [Last Name],\n\ Major Revision!\n\nPlease email us [JOURNAL STAFF NAME]\n\nSincerely,\n\n[EDITOR NAME]\n[EDITOR TITLE]\nPLOS Biology  \n
       LETTER
    end

    trait(:minor_revision) do
      name 'Editor Decision - Minor Revision'
      category 'minor_revision'
      body <<-LETTER.strip_heredoc
          ***EDIT THIS LETTER BEFORE SENDING****\n\nDear Dr. [Last Name],\n\n Minor Revision!\n\nSincerely,\n\n[EDITOR NAME]\n[EDITOR TITLE]\nPLOS Biology  \n
       LETTER
    end

    trait(:thank_reviewer) do
      name 'Reviewer Appreciation'
      subject 'Thank you for reviewing {{ journal.name }}'
      body <<-LETTER.strip_heredoc
        <p>Dear {{ reviewer.first_name }} {{ reviewer.last_name }}.</p><p>Kind regards,<br /> {{ journal.name }}</p>
      LETTER
    end
  end
end
