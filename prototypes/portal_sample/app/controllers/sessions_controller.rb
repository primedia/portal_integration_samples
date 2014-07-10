class SessionsController < ApplicationController
  layout 'login'

  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user
      redirect_to root_url, :notice => "Logged in"
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
