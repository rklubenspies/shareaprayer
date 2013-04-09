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
    @church = Church.find(params[:id], include: [:profile]).decorate
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
end
