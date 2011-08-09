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
      @prayer = current_user.prayers.build(:prayer => params[:prayer], :group_id => current_user.group.id, :facebook_share => params[:facebook], :source => "web")
    else
      @prayer = current_user.prayers.build(:prayer => params[:prayer], :facebook_share => params[:facebook], :source => "web")
    end
    
    save_state = @prayer.save
    
    if params[:facebook] == "1" && current_user.facebook && save_state
      current_user.facebook.feed!(
        :message => 'Prayer Request: ' + params[:prayer],
        :name => 'Share a Prayer'
      )
    end
    
    respond_to do |format|
      if save_state
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
