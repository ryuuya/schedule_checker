class PlansController < ApplicationController
  require 'xmlsimple'
  $user_id
  $tenki_url = "http://api.openweathermap.org/data/2.5/forecast"
  $search_url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite"
  $get_url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite"
  def index
    @weather_icons = []
    @plans = []
    $user_id = params[:user_id]
    p $user_id
    @user_name = User.find($user_id).name
    address = User.find_by(id: params[:user_id]).address
    res = Faraday.get $tenki_url, {q: address, APPID: "c82b64efba2a36c7dc188c410a386457",cnt: 5}
    tenkis = JSON.parse(res.body)
    tenkis["list"].each do |tenki|
      tenki["weather"].each do |weather|
        @weather_icons.push(weather["icon"])
      end
    end
    
    if Plan.exists?
      @length =  Plan.maximum("id") + 1
      if Plan.exists?(:user_id => $user_id)
        @plans = Plan.where(user_id: $user_id.to_i)
      else 
        Plan.exists?(:user_id => $user_id)
        @plans =[]
      end
    else
      @length = 1  
      @plans =[]
    end
    today = Time.now
    p Plan.exists?

    #カレンダーセット用データ
    @datas = []
    @today_plans = []
    @today_plans_link = []
    @plans.each do |data| 
      @datas += [
        'title' => data['title'],
        'start' => data['start_at'],
        'end' => data['end_at'],
        'url' => '/show/' + data['id'].to_s + "?user_id=" + params[:user_id],
        'color' => "#" + data.color.color_code
      ]
      if today.strftime("%m%d") == data['start_at'].strftime("%m%d")
        array = {}
        array["title"] = data['title']
        array["link"] = '/show/' + data['id'].to_s + "?user_id=" + params[:user_id]
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

  def show
    @plan = Plan.find(params[:id])
  end

  def destroy
    @plan = Plan.find(params[:id])
    id = @plan.user_id
    @plan.destroy
    redirect_to index_path + "?user_id=" + id.to_s
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.save
    redirect_to index_path + "?user_id" + id.to_s
  end

  def edit
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

  def update
    all = Plan.maximum("id")
    length = params[:id] 
    if all == nil
      all = 0
    end
    if length.to_i == all + 1
      @plan = Plan.new(plan_params)
      id = @plan.user_id
      @plan.save!
    else
      @plan = Plan.find(params[:id])
      id = @plan.user_id
      @plan.update(plan_params)
    end
    redirect_to index_path + "?user_id=" + id.to_s
  end
  
  def dictionary
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

  private
  def plan_params
    params[:plan].permit(:title, :detail, :start_at, :end_at, :color_id, :user_id)
  end
end
