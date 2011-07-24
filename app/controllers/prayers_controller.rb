class PrayersController < ApplicationController
  load_and_authorize_resource
  
  # GET /prayers
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /prayers/1
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /prayers/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /prayers/1/edit
  def edit
  end

  # POST /prayers
  def create
    respond_to do |format|
      if @prayer.save
        format.html { redirect_to @prayer, notice: 'Prayer was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /prayers/1
  def update
    respond_to do |format|
      if @prayer.update_attributes(params[:prayer])
        format.html { redirect_to @prayer, notice: 'Prayer was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
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
