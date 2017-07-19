class LandingController < ApplicationController
  layout 'landing'

  def guru
  end

  def user
  	session[:hide_email] = false
  end

  def about
  end
end
