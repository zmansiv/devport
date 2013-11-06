class Api::UsersController < ApplicationController
  before_filter :require_authorized_user!, only: [:destroy, :destroy_provider]

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