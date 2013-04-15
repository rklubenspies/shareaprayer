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
    if current_user.is_not_church_manager?(params[:id])
      redirect_to church_path(params[:id]), alert: "You must be a church manager to manage a church!"
    else
      @church = ManageChurchDecorator.decorate(
        Church.find(params[:id], include: [:profile])
      )
    end
  end

  # Inline updating for Chruch's manage page. Uses
  # best_in_place and respond_with_bip to facilitate
  # editing.
  # 
  # @author Robert Klubenspies
  # @since 1.0.0
  def update
    @church = Church.find(params[:id])

    respond_to do |format|
      if @church.update_attributes(params[:church])
        format.json { respond_with_bip(@chruch) }
      else
        format.json { respond_with_bip(@church) }
      end
    end
  end
end
