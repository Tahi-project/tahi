module TahiStandardTasks
  class PaperReviewerMailer < ActionMailer::Base
    include Rails.application.routes.url_helpers

    default from: ENV.fetch('FROM_EMAIL')

    def notify_invited(invitation_id:)
      invitation = Invitation.find(invitation_id)
      @invitee = invitation.invitee
      @paper = invitation.paper

      mail({
        to: invitation.email,
        subject: "You have been invited as a reviewer in Tahi"
      })
    end

    def notify_rescission(paper_id:, invitee_id:)
      @invitee = User.find invitee_id
      @paper = Paper.find paper_id

      mail({
        to: @invitee.email,
        subject: 'Your invitation to be a reviewer has been rescinded'
      })
    end
  end
end
