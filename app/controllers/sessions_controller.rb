class SessionsController < ApplicationController
  def index
    @user = current_user
    @sessions = @user.sessions
  end

  def create
    auth_data = request.env["omniauth.auth"]
    token = auth_data["credentials"]["token"]
    info = auth_data["extra"]["raw_info"]
    user = User.find_by github_id: info["login"]
    unless user
      user = User.create(
          github_token: token,
          name: info["name"],
          email: info["email"],
          avatar_url: info["avatar_url"],
          location: info["location"],
          bio: info["bio"],
          github_id: info["login"]
      )
    end
    log_in user
    redirect_to user_path user.github_id
  end

  def failure
    redirect_to :root
  end

  def destroy
    if params[:token]
      end_session params[:token]
      redirect_to sessions_path
    else
      log_out
      redirect_to :root
    end
  end
end