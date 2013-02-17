# A ChurchMembership is created when a user joins a church. It is
# used to keep track of people who belong to a church on SAP.
# Church managers are not stored in this table.
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchMembership < ActiveRecord::Base
  # @!attribute church_id
  #   @return [Integer] church's id
  #   @see Church

  # @!attribute user_id
  #   @return [Integer] user's id
  #   @see User

  attr_accessible :church_id, :user_id
  belongs_to :church
  belongs_to :user
end
