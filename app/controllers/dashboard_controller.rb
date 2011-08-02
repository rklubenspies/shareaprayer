class DashboardController < ApplicationController
  before_filter :redirect_to_home
  before_filter :check_screenname
  respond_to :html, :js
  
  def index
    @user = current_user
    if @user.group == nil
      @prayers = @user.prayers.order("created_at DESC").page(params[:page]).per(5)
    else
      @prayers = @user.group.prayer.order("created_at DESC").page(params[:page]).per(5)
    end
  end
  
  private
  def redirect_to_home
    if !user_signed_in?
      redirect_to root_path
    end
    false
  end
  
  def check_screenname
    if current_user.screenname == nil
      # redirect_to settings_path
    end
  end
end
