module UsersHelper
  def find_user
    @user = User.find_by github_id: params[:id]
    unless @user
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def format_date(date_string)
    month, year = date_string.split
    "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end
end