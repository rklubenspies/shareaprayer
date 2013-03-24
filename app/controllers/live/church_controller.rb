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
end
