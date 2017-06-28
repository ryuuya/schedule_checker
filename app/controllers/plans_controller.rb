class PlansController < ApplicationController
  require 'xmlsimple'
  tenki_url = "http://api.openweathermap.org/data/2.5/forecast"
  search_url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite"
  get_url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite"

  def index
    if res = login_check
      redirect_to root_path
    else
      @weather_icons = []
      user = User.find(session[:user_id])
      @user_id = session[:user_id]
      @plans = []
      if user.plans.count > 0
        @plans = user.plans
      end
      @user_name = User.find(@user_id).name
      address = user.address
      res = Faraday.get $tenki_url, {q: address, APPID: "c82b64efba2a36c7dc188c410a386457",cnt: 5}
      tenkis = JSON.parse(res.body)
      tenkis["list"].each do |tenki|
        tenki["weather"].each do |weather|
          @weather_icons.push(weather["icon"])
        end
      end

      #plansのデータ数を取得して
      if Plan.exists?
        @length =  Plan.maximum("id") + 1
        if Plan.exists?(:user_id => @user_id)
          @plans = Plan.where(user_id: @user_id.to_i)
        else 
          Plan.exists?(:user_id => @user_id)
          @plans =[]
        end
      else
        @length = 1  
        @plans =[]
      end
      today = Time.now

      #カレンダーセット用データ
      @datas = []
      @today_plans = []
      @today_plans_link = []
      @plans.each do |data| 
        @datas += [
          'title' => data['title'],
          'start' => data['start_at'],
          'end' => data['end_at'],
          'url' => '/show/' + data['id'].to_s,
          'color' => "#" + data.color.color_code
        ]
        if today.strftime("%m%d") == data['start_at'].strftime("%m%d")
          array = {}
          array["title"] = data['title']
          array["link"] = '/show/' + data['id'].to_s
          @today_plans.push(array)
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
  end

  def show
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.find(params[:id])
    end
  end

  def destroy
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.find(params[:id])
      @plan.user_id = session[:user_id]
      @plan.destroy
      redirect_to index_path 
    end
  end

  def new
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.new()
    end
  end

  def create
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.new(plan_params)
      @plan.user_id = session[:user_id]
      if @plan.title == ""
        redirect_to plans_new_path(:id => Plan.maximum("id") + 1),alert: "予定が未入力です。"
      elsif @plan.start_at > @plan.end_at
        redirect_to plans_new_path(:id => Plan.maximum("id") + 1),alert: "時間が不正です。"
      else
        @plan.save!
        redirect_to index_path 
      end
    end
  end

  def edit
    if res = login_check
      redirect_to root_path
    else
      all = Plan.maximum("id")
      if all == nil
        length = 1
        @plan = Plan.new()
      else
        length = params[:id]
        if length.to_i == all + 1
          @plan = Plan.new()
        else
          @plan = Plan.find(params[:id])
        end
      end
    end
  end

  def update
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.find(params[:id])
      @plan.user_id = session[:user_id]
      work = Plan.new(plan_params)
      if plan_params[:title] == ""
        redirect_to  plans_edit_path, alert: "予定が未入力です"
      else
        if work[:start_at] > work[:end_at]
          redirect_to plans_edit_path(:id => @plan.id),alert: "時間が不正です。"
        else
          @plan.update(plan_params)
          redirect_to index_path
        end
      end
    end
  end
  
  def dictionary
    if res = login_check
      redirect_to root_path
    else
      if params[:page] != nil
        use =  params[:page][:category]
      end
      key = params[:key_word]
      if key == nil
        @result_text = "ここに検索結果が表示されます"
      else
        result = Faraday.get $search_url, {
                                                Dic: use,
                                                Word: key,
                                                Scope: "HEADWORD",
                                                Match: "EXACT",
                                                Merge: "OR",
                                                Prof: "XHTML",
                                                PageSize: 1,
                                                PageIndex: 0
        }
        hash = Hash.from_xml(result.body)
        if hash["SearchDicItemResult"]["ItemCount"] == "0"
          @result_text = "該当結果はありません"
        else
          id = hash["SearchDicItemResult"]["TitleList"]["DicItemTitle"]["ItemID"]
          result = Faraday.get $get_url,{
                                          Dic: use,
                                          Item: id,
                                          Loc: "",
                                          Prof: "XHTML"
          }
          data = Hash.from_xml(result.body)
           if use == "EJdict"
            @result_text = data["GetDicItemResult"]["Body"]["div"]["div"]
          else use == "Edict"
            @result_text = data["GetDicItemResult"]["Body"]["div"]["div"]["div"][0]
          end
        end
      end
    end
  end
  def login_check
    result = false
    if session[:user_id] == nil
      result = true
    end
    return result;
  end

  private
  def plan_params
    params[:plan].permit(:title, :detail, :start_at, :end_at, :color_id, :user_id)
  end
end
