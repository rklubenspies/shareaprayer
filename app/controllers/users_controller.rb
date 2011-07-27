class UsersController < ApplicationController
  load_resource :find_by => :screenname
  authorize_resource

  # GET /users/screenname
  def show
    @prayers = @user.prayers.order("created_at DESC").page(params[:page]).per(5)
        
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /users/screenname/edit
  def edit
  end

  # PUT /users/screenname
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/screenname
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end
end
