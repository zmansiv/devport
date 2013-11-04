class UsersController < ApplicationController
  before_filter :require_user!, only: [:edit]

  def show
    @user = User.find_by github_id: params[:id]
    unless @user
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit
  end
end