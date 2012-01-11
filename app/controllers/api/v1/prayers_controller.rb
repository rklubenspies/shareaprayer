class Api::V1::PrayersController < Api::V1::BaseController
  def index
    last = params[:last].blank? ? Time.now.utc + 1.second : Time.parse(params[:last])
    @prayers = Prayer.feed(last)

    respond_to do |format|
      format.json  { render :json => @prayers }
      format.xml  { render :xml => @prayers }
    end
  end

  def show
    @prayer = Prayer.find(params[:id])
    
    respond_to do |format|
      format.json  { render :json => @prayer }
      format.xml  { render :xml => @prayer }
    end
  end

  def create
    # TODO: Persist via api
  end
end