# Processes requests
# 
# @since 1.0.0
# @author Robert Klubenspies
class Live::RequestsController < Live::ApplicationController
  # Create a request
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def create
    options = {
      text: params[:text],
      ip_address: request.env['REMOTE_ADDR']
    }
    church_id = params[:request][:church_id]

    posted_page = params[:request][:current_page]
    @prepend = (posted_page == "church-#{church_id}" || "recent") ? true : false

    raw_request = current_user.post_request(options, church_id)

    if raw_request
      @request = raw_request.decorate
    end

    respond_to do |format|
      if @request
        format.js { render template: "live/shared/request_form/success" }
      else
        format.js { render template: "live/shared/request_form/error"}
      end
    end
  end
end
