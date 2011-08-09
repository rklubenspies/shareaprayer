class DashboardController < ApplicationController
  before_filter :redirect_to_home
  before_filter :check_profile
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
  
  private
  def check_profile
    profile = current_user.profile
    if profile.name.nil?
      redirect_to settings_path, :alert => "Please ensure that all required profile fields are filled in before using Share a Prayer."
    end
  end
end
