# Prayers are created when a user prays for a Request
# 
# @since 1.0.0
# @author Robert Klubenspies
class Prayer < ActiveRecord::Base
  attr_accessible :ip_address, :request_id, :user_id
  belongs_to :user
  belongs_to :request

  validates :user_id, presence: true
  validates :request_id, presence: true
end
