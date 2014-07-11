class SessionsController < ApplicationController
  layout 'login'

  def new
    referer = request.referer
    if referer.present? && valid_url?(referer)
      session[:referer] = referer
    end
  end

  def create
    user = login(params[:email], params[:password])
    if user
      url = session[:referer] || root_url
      session[:referer] = nil
      redirect_to url
    end
  end

  def destroy
    reset_session
    cookies.delete :user_email, domain: '.apartmentguide.com'
    redirect_to login_path, notice: 'Login required'
  end

private
  def login email, password
    User.find(email).tap do |user|
      cookies[:user_email] = {
        domain: '.apartmentguide.com',
        value: Rails.application.config.verifier.generate(email)
      }
      session[:user_email] = user.email
    end
  end
end
