class HomeController < ApplicationController
  skip_authorization_check
  before_filter :redirect_to_dashboard
  
  def index
    @prayers = Prayer.order("created_at DESC").page(params[:page]).per(5)
  end
  
  private
  def redirect_to_dashboard
    if user_signed_in?
      redirect_to dashboard_path
    end
    false
  end
end
