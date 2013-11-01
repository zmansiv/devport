class UsersController < ApplicationController
  before_filter :require_user!, only: [:edit]

  def show
    @user = User.find_by github_id: params[:id]
  end

  def edit
  end
end