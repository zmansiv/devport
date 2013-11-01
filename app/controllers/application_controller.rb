class ApplicationController < ActionController::Base
  include SessionsActions

  protect_from_forgery

  ALERTS = %w(success info warning danger)
end