class UsersController < ApplicationController
  def new
    @new = User.new
  end
  def create
    @user = User.new(user_params)
    @user.save
    redirect_to users_index_path
  end
  def login
    @user = User.find_by_login_id params[:login_id]
    if @user && @user.authenticate(params[:password])
        render :text => "Login OK"
    else
        render :text => "Login NG"
    end
  end
  private
   def user_params
     params[:user].permit(:login_id, :name, :password, :password_confirmation, :address)
   end
end
