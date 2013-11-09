class Api::ImagesController < ApplicationController
  before_filter :require_authorized_user!, only: [:create]

  def create
    find_user
    proj = @user.projects.find_by(name: params[:project_name])
    render json: {status: :ok}
  end
end