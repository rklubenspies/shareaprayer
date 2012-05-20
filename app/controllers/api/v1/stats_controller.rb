# The Api:V1:StatsController provides a backend API for requesting statistical information.
# 
# @since 0.2.0
# @author Robert Klubenspies
class Api::V1::StatsController < Api::V1::BaseController
  http_basic_authenticate_with :name => ENV['STATS_AUTH_USERNAME'], :password => ENV['STATS_AUTH_PASSWORD']
  respond_to :json, :xml
  
  # Retrieves statistics about SAP
  # 
  # @since 0.2.0
  # @author Robert Klubenspies
  def index
    # Retrieve all prayer requests
    @prayers = Prayer.all.entries
    
    # Determine total request count
    @request_count = @prayers.count
    
    # Set prayers count to zero, then count out total prayers placed
    @prayers_count = 0
    @prayers.each do |prayer|
      @prayers_count = @prayers_count + prayer.times_prayed_for
    end
  end
end