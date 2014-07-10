class DashboardController < ApplicationController
  before_action :require_login, only: :index

  def index
  end

  def header_widget
    if current_user
      render partial: 'header'
    else
      render inline: "<script>window.location = '#{login_url}';</script>"
    end
  end
end
