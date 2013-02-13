# Stores an entry when someone reports content
# 
# @since 1.0.0
# @author Robert Klubenspies
class ReportedContent < ActiveRecord::Base
  # @!attribute priority
  #   @return [Integer] an integer representation of how important
  #     a report is. 0 is internal use, 9 is earth shattering

  # @!attribute reason
  #   @return [String] the reason why a user reported this content

  # @!attribute ip_address
  #   @return [String] the ip address used to report this content

  # @!attribute owner_id
  #   @return [Integer] the id of the user who owns this report

  # @!attribute reportable_id
  #   @return [Integer] the foreign key of the reported content's
  #     object

  # @!attribute reportable_type
  #   @return [String] the type of the reported content's object

  attr_accessible :priority, :reason, :ip_address
  belongs_to :reportable, polymorphic: true
  belongs_to :owner, class_name: "User"
end
