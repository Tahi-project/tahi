class PhasesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    paper = Paper.find_by_short_doi(params[:paper_short_doi])
    respond_with paper.phases
  end

  def create
    paper = Paper.find_by_short_doi(params[:phase][:paper_short_doi])
    phase = paper.phases.create!(new_phase_params)
    respond_with phase
  end

  def update
    phase = Phase.find params[:id]
    phase.update_attributes! update_phase_params
    respond_with phase
  end

  def show
    phase = Phase.find(params[:id])
    respond_with phase
  end

  def destroy
    phase = Phase.find params[:id]
    if phase.tasks.empty? && phase.destroy
      render json: true
    else
      render :nothing => true, :status => 400
    end
  end

  private

  def new_phase_params
    params.require(:phase).permit(:name, :position)
  end

  def update_phase_params
    params.require(:phase).permit(:name)
  end
end
