class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

#-------topページコントローラー-------
  def index
    session[:user_id] = nil
  end

#-------newページコントローラー-------
  def new
    session[:user_id] = nil
    @new = User.new
  end

#登録を実行
  def create
    user = User.new(user_params)
    check = User.find_by login_id: (params[:user][:login_id])
    params = params[:user]
    if params[:login_id].match(/^[ぁ-んァ-ン一-龥]/)
      redirect_to users_new_path, action: 'users_login', alert: "※IDは全角文字は使用できません。"
    else
      if check != nil
        redirect_to  users_new_path, action: 'users_login', alert: "※既に存在するIDです。別のIDで登録してください。"
      else
        if params[:login_id] == ""
          redirect_to  users_new_path, action: 'users_login', alert: "※IDが入力させていません。"
        elsif params[:name] == ""
        redirect_to  users_new_path, action: 'users_login', alert: "※名前が入力させていません。"
        elsif params[:address] == ""
          redirect_to users_new_path, action: 'users_login', alert: "※住所が入力されていません。"
        elsif params[:password] == ""
          redirect_to users_new_path, action: 'users_login', alert: "※パスワードが入力させていません。"
        else
          @user.save
          session[:user_id] = @user.id
          redirect_to index_path
        end
      end
    end
  end

#--------loginページコントローラー--------------
  def check
    @user = User.find_by login_id: (params[:user][:login_id])
    if @user && @user.authenticate(params[:user][:password_digest])
        redirect_to index_path
        session[:user_id] = @user.id
    else
        redirect_to users_login_path, action: 'users_login', alert: "※ログインできませんでした。もう一度お確かめください。"
    end
  end

  def login
    session[:user_id] = nil
    @user = User.new
  end

#--------logoutコントローラー-------------
  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

#--------user_showページコントローラー----
  def show
    if session[:user_id] == nil
      redirect_to root_path
    end
    id = params[:id]
    @user = User.find(id)
  end

#--------user_editページコントローラー---------
  def edit
    if session[:user_id] == nil
      redirect_to root_path
    end
    @user = User.find(params[:id])
  end

#編集を実行
  def update
    @user = User.find(params[:id])
    if user_params[:name] == ""
      redirect_to  user_edit_path, action: 'users_edit', alert: "※名前が入力させていません。"
    elsif user_params[:address] == ""
      redirect_to user_edit_path, action: 'users_edit', alert: "※住所が入力されていませ。"
    elsif user_params[:password] == ""
      redirect_to user_edit_path, action: 'users_edit', alert: "※パスワードが入力させていません。"
    else
      @user.update_attributes(user_params)
      redirect_to user_path
    end
  end

#-------errorページコントローラー---------
  def render_404
    render template: '/errors/error_404.html', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: '/errors/error_500.html', status: 500, layout: 'application', content_type: 'text/html'
  end

  private
   def user_params
     params[:user].permit(:login_id, :name, :password, :password_confirmation, :address)
   end
end
