class UsersController < ApplicationController
  before_filter :require_authorized_user!, only: [:edit]

  def show
    find_user
  end

  def edit
    p
    find_user
  end
end