module SessionsActions
  def current_user
    _current_session = Session.where(token: session[:token]).first
    @current_user ||= _current_session.nil? ? nil : _current_session.user
  end

  def log_in(user)
    ip = request.env["REMOTE_ADDR"]
    user_agent = request.env["HTTP_USER_AGENT"]
    new_session = user.sessions.build(ip: ip, user_agent: user_agent)
    session[:token] = new_session.token
  end

  def log_out
    end_session(session[:token])
  end

  def end_session(token)
    _session = Session.where(token: token).first
    _session.destroy if _session
    if token == session[:token]
      session[:token] = nil
      @current_user = nil
    end
  end
end