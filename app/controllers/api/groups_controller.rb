class Api::GroupsController < Api::ApiController
  load_and_authorize_resource
  
  # GET /groups
  def index
    respond_to do |format|
      format.json { render json: @groups }
    end
  end

  # GET /groups/friendly-id
  def show
    @prayers = @group.prayer.order("created_at DESC").page(params[:page]).per(5)

    respond_to do |format|
      format.json { render json: @group }
    end
  end

  # PUT /groups/friendly-id
  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.json { head :ok }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/friendly-id
  def destroy
    @group.destroy

    respond_to do |format|
      format.json { head :ok }
    end
  end
end
