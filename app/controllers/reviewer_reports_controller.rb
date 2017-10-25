##
# Controller for handling reviewer reports
#
# A reviewer report owns the nested question answers for a given review
#
class ReviewerReportsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def show
    requires_user_can :edit, reviewer_report.task
    render json: reviewer_report
  end

  def update
    requires_user_can :edit, reviewer_report.task
    update_review_date
    reviewer_report.submit! if reviewer_report_params[:submitted].present?

    # return the updated report if the due date changed
    render_report
  end

  private

  def render_report
    if reviewer_report_params.slice(:due_at).empty?
      respond_with reviewer_report
    else
      render json: reviewer_report
    end
  end

  def update_review_date
    if FeatureFlag[:REVIEW_DUE_DATE]
      due_at_date = reviewer_report_params.slice(:due_at)
      if due_at_date.present? && due_at_date['due_at'].to_datetime != reviewer_report.due_at
        requires_user_can :edit_due_date, reviewer_report.task
        reviewer_report.due_datetime.update_attributes due_at_date
      end
      reviewer_report.schedule_events if FeatureFlag[:REVIEW_DUE_AT]
    end
  end

  def reviewer_report
    @reviewer_report ||= ReviewerReport.find(params[:id])
  end

  def reviewer_report_params
    params.require(:reviewer_report)
      .permit(:submitted, :due_at)
  end
end
