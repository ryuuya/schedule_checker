class PlansController < ApplicationController
  def index
    @plans = Plan.all
    if Plan.exists?
      @length = Plan.maximum("id") + 1
    else
      @length = 1
    end
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
      if today.strftime("%m%d") == date['start_at'].strftime("%m%d")
        @today_plans.push(date['title'])
      end
    end
    if params[:day] == nil
      @day = today.strftime("%Y-%m-%d")
      @disp = "agendaWeek"
    else
      @day = params[:day]
      @disp = "agendaDay"
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
    all = Plan.maximum("id")
    length = params[:id]
    if length.to_i == all + 1
      @plan = Plan.new()
    else
      @plan = Plan.find(params[:id])
    end
  end

  def update
    all = Plan.maximum("id")
    length = params[:id]
    params[:user_id] = 1
    if length.to_i == all + 1
      @plan = Plan.new(plan_params)
      @plan.save!
    else
      @plan = Plan.find(params[:id])
      @plan.update(plan_params)
    end
    redirect_to index_path
  end

  private
  def plan_params
    params[:plan].permit(:title, :detail, :start_at, :end_at, :color_id, :user_id)
  end
end
