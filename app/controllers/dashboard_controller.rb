class DashboardController < ApplicationController
  before_filter :redirect_to_home
  before_filter :check_screenname
  respond_to :html, :js
  
  def index
    @user = current_user
    @prayers = @user.group.prayer.order("created_at DESC").page(params[:page]).per(5)
  end
  
  private
  def redirect_to_home
    if !user_signed_in?
      redirect_to root_path
    end
    false
  end
  
  def check_screenname
    if current_user.profile.screenname == nil
      # redirect_to settings_path
    end
  end
end
