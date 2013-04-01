# Stores an entry when someone reports content
# 
# @since 1.0.0
# @author Robert Klubenspies
class ReportedContent < ActiveRecord::Base
  # @!attribute priority
  #   @return [Integer] an integer representation of how important
  #     a report is. 0 is internal use, 9 is earth shattering
  
  attr_accessible :priority, :reason, :ip_address
  belongs_to :reportable, polymorphic: true
  belongs_to :owner, class_name: "User"
end
