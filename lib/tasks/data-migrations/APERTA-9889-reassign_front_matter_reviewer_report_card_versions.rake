namespace :data do
  namespace :migrate do
    desc <<-DESC
      Reassign correct CardVersion relationship for FrontMatterReviewerReports.

      A ReviewerReport will always have a Card associated to it through the
      CardVersion association.  This association helps determine the set of
      questions that is displayed to the end user.  When the ReviewerReport is
      initially created (using the ReviewerReportCreator service class), it
      will assign one of two different types of Cards -- either a
      ReviewerReport or a TahiStandardTasks::FrontMatterReviewerReport.  The
      ability to determine which of these two is assigned requires intimate
      knowledge of the Task instance that the Report is associated with and
      cannot be done simply by class name.  Compounding this issue is the fact
      that although there is an actual ReviewerReport class, there is no such
      thing as a TahiStandardTasks::FrontMatterReviewerReport model.

      This particular one time rake task will ensure that all
      FrontMatterReviewerReportTasks will have its front matter reviewer
      reports associated to the correct Card, so that the correct questions
      will be shown to the user on the front end.
    DESC
    task reassign_front_matter_reviewer_report_card_versions: :environment do
      Card.unscoped do # include soft deleted cards
        # --- skip execution if there is nothing to do
        unless Card.where(name: "FrontMatterReviewerReport").exists?
          message = "A Card with name 'FrontMatterReviewerReport' does not"\
              "exist, so skipping rake task execution."
          STDOUT.puts message
          next
        end

        new_card_version = Card.find_by_class_name!("TahiStandardTasks::FrontMatterReviewerReport")
                               .latest_published_card_version

        old_card_version = Card.find_by_class_name!("FrontMatterReviewerReport")
                               .latest_published_card_version

        # --- move reviewer report to new card version
        TahiStandardTasks::FrontMatterReviewerReportTask.find_each do |fmrrt|
          fmrrt.reviewer_reports.update_all(card_version_id: new_card_version)
        end

        # --- move old answers to new card content
        Answer.unscoped do # include soft deleted answers
          idents = new_card_version.card_contents.pluck(:ident).compact
          idents.each do |ident|
            old_content = old_card_version.card_contents.find_by(ident: ident)
            new_content = new_card_version.card_contents.find_by(ident: ident)

            STDOUT.puts "Updating #{old_content.answers.count} answers for ident '#{ident}'"
            old_content.answers.update_all(card_content_id: new_content.id)

            # rubocop:disable Style/Next
            # assert that all answers have been moved to new new card content
            if old_content.reload.answers.any?
              message = "Failed attempting to move all answers for ident #{ident}"
              STDERR.puts(message)
              raise message
            end
            # rubocop:enable Style/Next
          end
        end

        # -- destroy the old card, since everything has moved to the new one
        # -- be sure to work around:
        # --    acts_as_paranoid,
        # --    active_record callback validations,
        # --    acts_as_state_machine limitations,
        # --    event stream notifications
        old_card = Card.find_by_class_name!("FrontMatterReviewerReport")
        old_card.recover if old_card.destroyed?
        old_card.state = "draft"
        old_card.notifications_enabled = false
        STDOUT.puts "Destroying unused `FrontMatterReviewerReport` card ..."
        old_card.destroy_fully!

        if Card.where(name: "FrontMatterReviewerReport").exists?
          message = "Unable to destroy Card with name `FrontMatterReviewerReport`"
          STDERR.puts(message)
          raise message
        end
      end
    end
  end
end
