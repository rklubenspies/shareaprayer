# Prayers are created when a user prays for a Request
# 
# @since 1.0.0
# @author Robert Klubenspies
class Prayer < ActiveRecord::Base
  # @!attribute user_id
  #   @return [Integer] user's id
  #   @see User

  # @!attribute request_id
  #   @return [Integer] request's id
  #   @see Request

  # @!attribute ip_address
  #   @return [String] the ip address used to pray for the request

  attr_accessible :ip_address, :request_id, :user_id
  belongs_to :user
  belongs_to :request

  validates :user_id, presence: true
  validates :request_id, presence: true
end
