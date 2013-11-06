class Api::UsersController < ApplicationController
  before_filter :require_authorized_user!, only: [:sync_provider, :destroy, :destroy_provider]

  def index
    render json: User.all
  end

  def show
    find_user
    render json: @user
  end

  def sync_provider
    case params[:provider]
      when "github"
        current_user.sync_github_data
        current_user.save
        flash[:success] = "Synced GitHub data"
        render json: {status: :ok}
      when "linkedin"
        current_user.sync_linkedin_data
        current_user.save
        flash[:success] = "Synced LinkedIn data"
        render json: {status: :ok}
      else
        flash[:danger] = "Unknown auth provider!"
        render json: {status: :not_found}
    end
  end

  def destroy
    find_user
    @user.destroy
    flash[:warning] = "Account deleted"
    render json: {status: :ok}
  end

  def destroy_provider
    case params[:provider]
      when "linkedin"
        current_user.linkedin_id = nil
        current_user.linkedin_token = nil
        current_user.linkedin_secret = nil
        current_user.save
        flash[:info] = "Disconnected LinkedIn account"
        render json: {status: :ok}
      else
        flash[:danger] = "Unknown auth provider!"
        render json: {status: :not_found}
    end
  end
end