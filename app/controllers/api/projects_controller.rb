class Api::ProjectsController < ApplicationController
  before_filter :require_authorized_user!, only: [:reorder, :destroy]

  def reorder
    find_user
    params[:projects].each do |name, pos|
      proj = @user.projects.find_by(name: name)
      proj.display_pos = pos
      proj.save
    end
    render json: {status: :ok}
  end

  def destroy
    find_user
    @user.projects.find_by(name: params[:project_name]).destroy
    render json: {status: :ok}
  end
end