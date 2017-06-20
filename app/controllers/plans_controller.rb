class PlansController < ApplicationController
  def index
    plans = Plan.all
    
    #カレンダーセット用データ
    @datas = []
    plans.each do |date| 
      @datas = [
        'title' => date['title'],
        'start' => date['start_at']
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
end
