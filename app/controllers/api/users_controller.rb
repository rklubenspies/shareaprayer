class Api::UsersController < Api::ApiController
  load_resource :find_by => :screenname
  authorize_resource
  respond_to :json

  # GET /profile/screenname
  def show
    respond_with(:api, @user)
  end

  # PUT /profile/screenname
  def update
    respond_with(:api, @user)
  end

  # DELETE /profile/screenname
  def destroy
    @user.destroy
    respond_with(:api, @user)
  end
end
