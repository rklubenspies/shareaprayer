class PrayersController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => [:create]

  # GET /prayers/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # POST /prayers
  def create
    if current_user.group != nil
      @prayer = current_user.prayers.build(:prayer => params[:prayer], :group_id => current_user.group.id, :source => "web")
    else
      @prayer = current_user.prayers.build(:prayer => params[:prayer], :source => "web")
    end
    
    respond_to do |format|
      if @prayer.save
        format.js
      else
        format.js { render :partial => 'error' }
      end
    end
  end

  # DELETE /prayers/1
  def destroy
    respond_to do |format|
      if @prayer.destroy
        format.js
      else
        format.js { render :partial => 'error' }
      end
    end
  end
end
