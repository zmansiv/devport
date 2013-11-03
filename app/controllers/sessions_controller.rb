class SessionsController < ApplicationController
  before_filter :require_user!, only: [:index, :destroy]
  before_filter :require_no_user!, only: [:create]

  def index
    @user = current_user
    @sessions = @user.sessions
  end

  def create
    auth_data = request.env["omniauth.auth"]
    user = User.find_or_create_from_github auth_data
    log_in user
    redirect_to user_path user.github_id
  end

  def failure
    redirect_to :root
  end

  def destroy
    if params[:id]
      end_session params[:id]
      render json: {status: :ok}
    else
      log_out
      render json: {status: :ok}
    end
  end
end