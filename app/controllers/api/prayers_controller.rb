class Api::PrayersController < Api::ApiController
  load_and_authorize_resource
  respond_to :json
  
  # GET /prayers.json
  def index
    respond_with(:api, @prayers)
  end

  # GET /prayers/1.json
  def show
    respond_with(:api, @prayer)
  end

  # GET /prayers/new.json
  def new
    respond_with(:api, @prayer)
  end

  # POST /prayers.json
  def create
    respond_with(:api, @prayer)
  end

  # PUT /prayers/1.json
  def update
    respond_with(:api, @prayer)
  end

  # DELETE /prayers/1.json
  def destroy
    @prayer.destroy
    respond_with(:api, @prayer)
  end
end
