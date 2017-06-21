class PlansController < ApplicationController
  def index
    @plans = Plan.all
    @length = Plan.maximum("id") + 1
    today = Time.now
    #カレンダーセット用データ
    @datas = []
    @today_plans = []
    @plans.each do |date| 
      @datas += [
        'title' => date['title'],
        'start' => date['start_at'],
        'end' => date['end_at'],
        'url' => '/show/' + date['id'].to_s
      ]
      p today.strftime("%m%d")
      if today.strftime("%m%d") == date['start_at'].strftime("%m%d")
        @today_plans.push(date['title'])
      end
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
