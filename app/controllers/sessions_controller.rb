class SessionsController < ApplicationController
  before_filter :require_user!, only: [:index, :destroy]

  def index
    @user = current_user
    @sessions = @user.sessions
  end

  def create
    auth_data = request.env["omniauth.auth"]
    case params[:provider]
      when "github"
        user = User.find_or_create_from_github auth_data
        log_in user
        flash[:success] = "Signed in"
        redirect_to user_path user.github_id
      when "linkedin"
        return unless require_user!
        current_user.linkedin_id = auth_data["uid"]
        current_user.linkedin_token = auth_data["credentials"]["token"]
        current_user.linkedin_secret = auth_data["credentials"]["secret"]
        current_user.sync_linkedin_data
        flash[:success] = "Connected LinkedIn account"
        redirect_to user_path current_user.github_id
      else
        flash[:danger] = "Unknown auth provider!"
        redirect_to :root
    end
  end

  def failure
    flash[:danger] = "Authentication failed"
    redirect_to :root
  end

  def destroy
    if params[:id]
      end_session params[:id]
      render json: {status: :ok}
    else
      log_out
    end
  end
end