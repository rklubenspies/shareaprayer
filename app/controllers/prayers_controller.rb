class PrayersController < ApplicationController
  load_and_authorize_resource

  # GET /prayers/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /prayers/1
  def destroy
    @prayer.destroy

    respond_to do |format|
      format.html { redirect_to prayers_url }
    end
  end
end
