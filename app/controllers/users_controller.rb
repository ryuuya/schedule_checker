class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500
  def index
  end
  def new
    @new = User.new
  end
  def create
    @user = User.new(user_params)
    @check = User.find_by login_id: (params[:user][:login_id])
    if @check != nil
      redirect_to  users_new_path, action: 'users_login', alert: "※既に存在するIDです。別のIDで登録してください。"
    else
      @user.save
      redirect_to index_path + "?user_id=" + @user.id.to_s
    end
  end
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
    @user = User.new
  end
  def logout
    session[:user_id] = nil
    redirect_to root_path
  end
  def show
    id = params[:id]
    @user = User.find(id)
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    redirect_to user_path 
  end
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
