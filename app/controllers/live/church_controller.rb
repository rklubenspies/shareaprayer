# Displays churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Live::ChurchController < Live::ApplicationController
  # Displays a single church's feed and information
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def show
    @church = ShowChurchDecorator.decorate(
      Church.find(params[:id], include: [:profile])
    )
    @requests = @church.requests.order("created_at DESC").page(params[:page]).decorate

    respond_to do |format|
      if @requests && @requests.count > 0
        format.js { render template: "live/shared/pagination" }
      elsif @requests
        response.headers["X-SAP-End-Of-List"] = "1"
        format.js { render text: "" }
      end
      
      format.html
    end
  end
  
  # Join a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def join
    church = Church.find(params[:id])
    if current_user.join_church(church.id)
      redirect_to church_path(church.subdomain), notice: "Successfully joined prayer group!"
    else
      redirect_to church_path(church.subdomain), alert: "We encountered an unknown error. Please try again later."
    end
  end

  # Leave a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def leave
    church = Church.find(params[:id])
    if current_user.leave_church!(church.id)
      redirect_to church_path(church.subdomain), notice: "Successfully left prayer group!"
    else
      redirect_to church_path(church.subdomain), alert: "We encountered an unknown error. Please try again later."
    end
  end

  # Manage a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def manage
    if current_user.is_church_manager?(params[:id])
      @church = ManageChurchDecorator.decorate(
        Church.find(params[:id], include: [:profile])
      )
    else
      redirect_to church_path(params[:id]), alert: "You must be a church manager to manage a church!"
    end
  end

  # Updates a Church's profile
  # 
  # @author Robert Klubenspies
  # @since 1.0.0
  def update_profile
    if current_user.is_not_church_manager?(params[:id])
      redirect_to church_path(params[:id]), alert: "You must be a church manager to update a church's profile!"
    end

    church = Church.find(params[:id])
    params[:church][:bio] = params[:bio]

    update = church.update_data!(params[:church])

    if update
      @church = ManageChurchDecorator.decorate(
        Church.find(params[:id], include: [:profile])
      )
    end

    respond_to do |format|
      if @church
        format.html { redirect_to manage_church_path(params[:id]), notice: "Profile updated!" }
      else
        format.html { redirect_to manage_church_path(params[:id]), error: "There was an unknown error! Please try again later." }
      end
    end
  end
end
