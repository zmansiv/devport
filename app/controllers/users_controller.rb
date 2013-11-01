class UsersController < ApplicationController
  def show
    @user = User.find_by github_id: params[:id]
  end

  def edit
  end
end