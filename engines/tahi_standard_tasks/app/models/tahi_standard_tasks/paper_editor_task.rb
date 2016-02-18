module TahiStandardTasks
  class PaperEditorTask < Task
    DEFAULT_TITLE = 'Invite Editor'
    DEFAULT_ROLE = 'admin'

    include Invitable

    def invitation_invited(invitation)
      if paper.authors_list.present?
        invitation.update! information: "Here are the authors on the paper:\n\n#{paper.authors_list}"
      end
      PaperEditorMailer.delay.notify_invited({
        invitation_id: invitation.id
      })
    end

    def invitation_accepted(invitation)
      replace_editor invitation
      PaperAdminMailer.delay.notify_admin_of_editor_invite_accepted(
        paper_id:  invitation.paper.id,
        editor_id: invitation.invitee.id
      )
    end

    def invitee_role
      Role::ACADEMIC_EDITOR_ROLE
    end

    def invite_letter
      template = <<-TEXT.strip_heredoc
        Dear [EDITOR NAME],

        I would love to invite you to be an editor for %{manuscript_title}.  View the manuscript on Tahi and let me know if you accept or reject this offer.

        Thank you,
        [YOUR NAME]
        %{journal_name}

      TEXT

      template % template_date
    end

    private

    def template_date
      { manuscript_title: paper.display_title(sanitized: false),
        journal_name: paper.journal.name }
    end

    def replace_editor(invitation)
      user = User.find(invitation.invitee_id)
      role = paper.journal.academic_editor_role

      # Remove any old editors
      paper.assignments.where(role: role).destroy_all
      paper.assignments.where(user: user, role: role).first_or_create!
    end
  end
end
