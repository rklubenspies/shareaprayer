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
    @requests = @church.requests.order("created_at DESC").decorate
  end
  # Join a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def join
    if current_user.join_church(params[:id])
      redirect_to live_church_path(params[:id]), notice: "Successfully joined prayer group!"
    else
      redirect_to live_church_path(params[:id]), alert: "We encountered an unknown error. Please try again later."
    end
  end

  # Leave a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def leave
    if current_user.leave_church!(params[:id])
      redirect_to live_church_path(params[:id]), notice: "Successfully left prayer group!"
    else
      redirect_to live_church_path(params[:id]), alert: "We encountered an unknown error. Please try again later."
    end
  end
end
