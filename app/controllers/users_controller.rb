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
  end
  private
   def user_params
     params[:user].permit(:login_id, :name, :password, :address)
   end
end
