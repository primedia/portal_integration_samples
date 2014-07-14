require 'uri'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_p3p

  def require_login
    unless current_user
      redirect_to login_path, notice: 'Login required'
    end
  end

  def valid_url? url
    !!(url =~ URI::regexp)
  end

private
  def current_user
    @current_user ||= User.find(session[:user_email]) if session[:user_email]
  end

  helper_method :current_user

  def set_p3p
    headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"'
  end
end
