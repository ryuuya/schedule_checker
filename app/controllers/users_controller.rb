class UsersController < ApplicationController
  def new
    @new = User.new
  end
  def create
    @user = User.new(user_params)
    @user.save
    redirect_to index_path
  end
  def check
    @user = User.find_by login_id: (params[:user][:login_id])
    if @user && @user.authenticate(params[:user][:password_digest])
        redirect_to index_path
    else
        redirect_to  users_login_path
    end
  end
  def login
    @user = User.new
  end

  private
   def user_params
     params[:user].permit(:login_id, :name, :password, :password_confirmation, :address)
   end
end
