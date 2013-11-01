class ApplicationController < ActionController::Base
  include SessionsActions

  protect_from_forgery
end