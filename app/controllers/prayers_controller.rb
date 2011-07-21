class PrayersController < ApplicationController
  load_and_authorize_resource
  
  # GET /prayers
  # GET /prayers.json
  def index
    @prayers = Prayer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prayers }
    end
  end

  # GET /prayers/1
  # GET /prayers/1.json
  def show
    @prayer = Prayer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prayer }
    end
  end

  # GET /prayers/new
  # GET /prayers/new.json
  def new
    @prayer = Prayer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prayer }
    end
  end

  # GET /prayers/1/edit
  def edit
    @prayer = Prayer.find(params[:id])
  end

  # POST /prayers
  # POST /prayers.json
  def create
    @prayer = Prayer.new(params[:prayer])

    respond_to do |format|
      if @prayer.save
        format.html { redirect_to @prayer, notice: 'Prayer was successfully created.' }
        format.json { render json: @prayer, status: :created, location: @prayer }
      else
        format.html { render action: "new" }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prayers/1
  # PUT /prayers/1.json
  def update
    @prayer = Prayer.find(params[:id])

    respond_to do |format|
      if @prayer.update_attributes(params[:prayer])
        format.html { redirect_to @prayer, notice: 'Prayer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @prayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prayers/1
  # DELETE /prayers/1.json
  def destroy
    @prayer = Prayer.find(params[:id])
    @prayer.destroy

    respond_to do |format|
      format.html { redirect_to prayers_url }
      format.json { head :ok }
    end
  end
end
