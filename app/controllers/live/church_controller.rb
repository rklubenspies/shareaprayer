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
    raw_church = Church.find(params[:id], include: [:profile, :subscription])

    if raw_church.subscription.past_due?
      if current_user.is_church_manager?(raw_church.id)
        redirect_to root_path, alert: "Your church's page is past due! Please contact support."
      else
        redirect_to root_path, notice: "We can't display this page right now."
      end
    elsif raw_church.subscription.canceled?
      redirect_to root_path, alert: "The plan associated with that church has been cancelled."
    elsif raw_church.subscription.active?  
      @church = ShowChurchDecorator.decorate(raw_church)
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

    params[:church][:bio] = params[:bio]
    church = Church.find(params[:id])
    update = church.update_data!(params[:church])

    respond_to do |format|
      if update
        format.html { redirect_to manage_church_path(params[:id]), notice: "Profile updated!" }
      else
        format.html { redirect_to manage_church_path(params[:id]), error: "There was an unknown error! Please try again later." }
      end
    end
  end
end
