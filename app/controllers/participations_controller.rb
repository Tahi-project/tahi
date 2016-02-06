class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :must_be_able_to_view_participants, only: [:index, :show]
  before_action :must_be_able_to_add_participants, only: [:create]
  before_action :must_be_able_to_remove_participants, only: [:destroy]
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    respond_with task.participations, root: :participations
  end

  def create
    if participation.save
      # create new R&P assignment
      Assignment.where(
        user: participation.user,
        role: task.journal.roles.participant,
        assigned_to: participation.task
      ).first_or_create!

      CommentLookManager.sync_task(task)
      if participation.user_id != current_user.id
        participation.task.notify_new_participant(current_user, participation)
      end
      Activity.participation_created! participation, user: current_user
    end
    respond_with participation
  end

  def show
    respond_with participation
  end

  def destroy
    # destroy new R&P assignment
    Assignment.where(
      user: participation.user,
      role: task.journal.roles.participant,
      assigned_to: participation.task
    ).destroy_all

    participation.destroy
    Activity.participation_destroyed! participation, user: current_user
    respond_with participation
  end

  private

  def task
    @task ||= begin
      if params[:id].present?
        participation.task
      elsif params[:task_id]
        Task.find(params[:task_id])
      else
        Task.find(participation_params[:task_id])
      end
    end
  end

  def participation
    @participation ||= begin
      if params[:id].present?
        Participation.find(params[:id])
      else
        Participation.new(participation_params)
      end
    end
  end

  def participation_params
    params.require(:participation).permit(:task_id, :user_id)
  end

  def render_404
    head 404
  end

  def must_be_able_to_view_participants
    fail AuthorizationError unless current_user.can?(:view_participants, task)
  end

  def must_be_able_to_add_participants
    fail AuthorizationError unless current_user.can?(:add_participants, task)
  end

  def must_be_able_to_remove_participants
    fail AuthorizationError unless current_user.can?(:remove_participants, task)
  end
end
