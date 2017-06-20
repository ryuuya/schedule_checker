class PlansController < ApplicationController
  def index
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to index_path
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.update(plan_params)
    redirect_to index_path
  end

  private
  def plan_params
    params[:plan].permit(:title, :detail, :start_at, :end_at, :color_id)
  end
end
