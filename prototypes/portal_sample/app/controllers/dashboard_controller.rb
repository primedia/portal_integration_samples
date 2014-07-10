class DashboardController < ApplicationController
  before_action :require_login

  def index
  end

  def header_widget
    render partial: 'header'
  end
end
