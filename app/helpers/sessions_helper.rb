module SessionsHelper
  def current_user
    _current_session = Session.find_by token: session[:token]
    @current_user ||= _current_session.nil? ? nil : _current_session.user
  end

  def log_in(user)
    ip = request.env["REMOTE_ADDR"]
    user_agent = request.env["HTTP_USER_AGENT"]
    new_session = user.sessions.create ip: ip, user_agent: user_agent
    session[:token] = new_session.token
  end

  def log_out
    end_session Session.find_by(token: session[:token]).id
    flash[:warning] = nil
    flash[:info] = "Signed out"
    redirect_to :root
  end

  def end_session(id)
    _session = Session.find id
    token = _session.token
    _session.destroy if _session
    if token == session[:token]
      session[:token] = nil
      @current_user = nil
      flash[:warning] = "Signed out"
    end
  end

  def require_user!
    unless current_user
      flash[:danger] = "You need to be logged in to do that!"
      redirect_to :root
      return false
    end
    true
  end

  def require_no_user!
    if current_user
      flash[:danger] = "You can't do that while logged in!"
      redirect_to user_path current_user.github_id
      return false
    end
    true
  end

  def require_authorized_user!
    return unless require_user!
    unless current_user.github_id == params[:id]
      flash[:danger] = "You aren't authorized to do that!"
      redirect_to :root
      return false
    end
    true
  end
end