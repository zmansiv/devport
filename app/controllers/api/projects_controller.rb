class Api::ProjectsController < ApplicationController
  before_filter :require_authorized_user!, only: [:reorder]

  def reorder
    find_user
    params[:projects].each do |name, pos|
      proj = @user.projects.find_by(name: name)
      proj.display_pos = pos
      proj.save
    end
    render json: {status: :ok}
  end
end