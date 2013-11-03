module SessionsActions
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
    end_session session[:token]
  end

  def end_session(id)
    _session = Session.find id
    token = _session.token
    _session.destroy if _session
    if token == session[:token]
      session[:token] = nil
      @current_user = nil
    end
  end

  def require_user!
    unless current_user
      flash[:warning] = "You need to be logged in to do that!"
      redirect_to :root
    end
  end

  def require_no_user!
    if current_user
      flash[:warning] = "You can't do that while logged in!"
      redirect_to user_path current_user.github_id
    end
  end
end