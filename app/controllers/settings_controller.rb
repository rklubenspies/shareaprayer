class SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to user_path(current_user.screenname), notice: 'Profile was successfully updated!' }
      else
        format.html { render action: "index" }
      end
    end
  end
end
