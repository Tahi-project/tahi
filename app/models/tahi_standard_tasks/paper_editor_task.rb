module TahiStandardTasks
  class PaperEditorTask < Task
    include ClientRouteHelper
    include Rails.application.routes.url_helpers
    DEFAULT_TITLE = 'Invite Academic Editor'.freeze
    DEFAULT_ROLE_HINT = 'admin'.freeze

    include Invitable

    def task_added_to_paper(paper)
      super
      create_invitation_queue!
    end

    def academic_editors
      paper.academic_editors
    end

    def invitation_invited(invitation)
      invitation.body = add_invitation_link(invitation)
      invitation.save!
      PaperEditorMailer.delay.notify_invited invitation_id: invitation.id
    end

    def invitation_accepted(invitation)
      add_invitee_as_academic_editor_on_paper!(invitation)
    end

    def invitation_rescinded(invitation)
      if invitation.invitee.present?
        invitation.invitee.resign_from!(assigned_to: invitation.task.journal,
                                        role: invitation.invitee_role)
      end
    end

    def active_invitation_queue
      self.invitation_queue || InvitationQueue.create(task: self)
    end

    def invitee_role
      Role::ACADEMIC_EDITOR_ROLE
    end

    def invitation_template
      LetterTemplate.new(
        salutation: "Dear Dr. [EDITOR NAME],",
        body: invitation_body
      )
    end

    def add_invitation_link(invitation)
      old_invitation_url = client_dashboard_url
      new_invitation_url = client_dashboard_url(
        invitation_token: invitation.token
      )
      invitation.body.gsub old_invitation_url, new_invitation_url
    end

    private

    # This method is a bunch of english text. It should be moved to
    # its own file, but we're not sure where. It's here, instead of a
    # mailer template, because users can edit the text before it gets
    # sent out.
    # rubocop:disable Metrics/MethodLength
    def invitation_body
      template = <<-TEXT.strip_heredoc
        <p>I am writing to seek your advice as the academic editor on a manuscript entitled '%{manuscript_title}'. The corresponding author is %{author_name}, and the manuscript is under consideration at %{journal_name}.</p>

        <p>
We would be very grateful if you could let us know whether or not you are able to take on this assignment within 24 hours, so that we know whether to await your comments, or if we need to approach someone else. To accept or decline the assignment via our submission system, please use the link below. If you are available to help and have no conflicts of interest, you also can view the entire manuscript via this link.</p>
        <p><a href="%{dashboard_url}">View Invitation</a></p>

        <p>If you do take this assignment, and think that this work is not suitable for further consideration by %{journal_name}, please tell us if it would be more appropriate for one of the other PLOS journals, and in particular, PLOS ONE (<a href="http://plos.io/1hPjumI">http://plos.io/1hPjumI</a>). If you suggest PLOS ONE, please let us know if you would be willing to act as Academic Editor there. For more details on what this role would entail, please go to <a href="http://journals.plos.org/plosone/s/journal-information ">http://journals.plos.org/plosone/s/journal-information</a>.</p>
        <p>I have appended further information, including a copy of the abstract and full list of authors below.</p>
        <p>My colleagues and I are grateful for your support and advice. Please don't hesitate to contact me should you have any questions.</p>
        <p>Kind regards,</p>
        <p>[YOUR NAME]</p>
        <p>%{journal_name}</p>
        <p>***************** CONFIDENTIAL *****************</p>
        <p>%{paper_type}</p>
        <p>
          Manuscript Title:<br>
          %{manuscript_title}
        </p>
        <p>
          Authors:<br>
          %{authors}
        </p>
        <p>
          Abstract:<br>
          %{abstract}
        </p>
        <p>To view this manuscript, please use the link presented above in the body of the e-mail.</p>
        <p>You will be directed to your dashboard in Aperta, where you will see your invitation. Selecting "yes" confirms your assignment as Academic Editor. Selecting "yes" to accept this assignment will allow you to access the full submission from the Dashboard link in your main menu.</p>
      TEXT
      template % template_data
    end
    # rubocop:enable Metrics/LineLength, Metrics/MethodLength

    def add_invitee_as_academic_editor_on_paper!(invitation)
      invitee = User.find(invitation.invitee_id)
      paper.add_academic_editor(invitee)
    end

    def template_data
      {
        manuscript_title: paper.display_title(sanitized: false),
        paper_type: paper.paper_type,
        journal_name: paper.journal.name,
        author_name: paper.creator.full_name,
        authors: AuthorsList.authors_list(paper),
        abstract: abstract,
        dashboard_url: client_dashboard_url
      }
    end

    def abstract
      return 'Abstract is not available' unless paper.abstract
      paper.abstract
    end
  end
end