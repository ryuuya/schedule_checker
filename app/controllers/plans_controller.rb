class PlansController < ApplicationController
  def index
    plans = Plan.all
    
    #カレンダーセット用データ
    @datas = []
    plans.each do |date| 
      @datas = [
        'title' => date['title'],
        'start' => date['start_at'],
        'url' => '/show/' + date['id'].to_s
      ]
    end
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
    all = Plan.all
    if params[:id] == all.length + 1
      @plan = Plan.new
    else
      @plan = Plan.find(params[:id])
    end
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
