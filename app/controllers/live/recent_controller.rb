# Displays recent requests
# 
# @since 1.0.0
# @author Robert Klubenspies
class Live::RecentController < Live::ApplicationController
  # Displays a recent request from all the current user's churches
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def index
    @requests = current_user.church_requests.order("created_at DESC").page(params[:page]).decorate

    respond_to do |format|
      format.js { render template: "live/shared/pagination" }
      format.html
    end
  end
end
