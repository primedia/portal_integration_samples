class DashboardController < ApplicationController
  before_action :require_login, only: :index
  protect_from_forgery except: :header_widget

  def index
  end

  def header_widget
    if current_user
      @header_template = merged_header_template
      render partial: "templates/header_widget.js"
    else
      render js: "window.location = '#{login_url}';"
    end
  end

private
  def merged_header_template
    template_path = "#{Rails.root}/app/views/templates/_header.html.slim"
    Slim::Template.new(template_path).render(self, {})
  end
end
