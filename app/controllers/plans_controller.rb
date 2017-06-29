class PlansController < ApplicationController
  require 'xmlsimple'

#カレンダーページ
  def index
  tenki_url = "http://api.openweathermap.org/data/2.5/forecast"
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
      
      #api例外処理
      if address == "北海道"
        address = "hokkaido"
      elsif address == "神奈川県"
        address = "kanagawa"
      elsif address == "埼玉県"
        address = "saitame"
      elsif address == "山梨県"
        address = "yamanashi"
      elsif address == "愛知県"
        address = "aichi"
      elsif address == "滋賀県"
        address = "shiga"
      elsif address == "香川県"
        address = "kagawa"
      elsif address == "愛媛県"
        address = "ehime"
      end
      
      res = Faraday.get tenki_url, {q: address, APPID: "c82b64efba2a36c7dc188c410a386457",cnt: 5}
      tenkis = JSON.parse(res.body)
      tenkis["list"].each do |tenki|
        tenki["weather"].each do |weather|
          @weather_icons.push(weather["icon"])
        end
      end
      @length = 1

      #plansのデータで一番大きいID + 1を取得
      if Plan.exists?
        @length =  Plan.maximum("id") + 1
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

      #初期表示の日付設定、
      if params[:day] == nil
      @day = today.strftime("%Y-%m-%d")
        @disp = "agendaWeek"
      else
        @day = params[:day]
        @disp = "agendaDay"
      end
    end
  end

#予定の詳細ページ
  def show
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.find(params[:id])
    end
  end

#予定を削除
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

#予定の登録ページ
  def new
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.new()
    end
  end

#登録を実行
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

#予定の編集ページ
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

#編集を実行
  def update
    if res = login_check
      redirect_to root_path
    else
      @plan = Plan.find(params[:id])
      @plan.user_id = session[:user_id]
      work = Plan.new(plan_params)

      #未入力check
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

#辞書ページ
  def dictionary
  get_url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite"
  search_url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite"
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
        result = Faraday.get search_url, {
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
          result = Faraday.get get_url,{
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

#ログイン状況の確認
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
