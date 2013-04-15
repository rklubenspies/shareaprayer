# Search churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Live::SearchController < Live::ApplicationController
  # Displays search form and results
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def index
  end
  
  # Query for churches
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def query
    @churches = Church.search_name_and_subdomain(params[:q])

    respond_to do |format|
      if !@churches.empty?
        format.js { render template: "live/search/results" }
      else
        format.js { render template: "live/search/no_results"}
      end
    end
  end
end
