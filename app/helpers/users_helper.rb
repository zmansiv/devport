module UsersHelper
  def find_user
    @user = User.find_by github_id: params[:id]
    unless @user
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end