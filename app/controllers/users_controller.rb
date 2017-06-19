class UsersController < ApplicationController
  def new
    @new = User.new
  end
end
