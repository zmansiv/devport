class SessionsController < ApplicationController
  def index
  end

  def create
    puts "eiofjoeijfoiiofioej"
    render json: request.env["omniauth.auth"]
  end

  def failure

  end
end