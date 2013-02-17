# A ChurchManagership is created when a user joins a church. It
# is used to keep track of people who manage a church on SAP.
# Church members are not stored in this table.
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchManagership < ActiveRecord::Base
  # @!attribute church_id
  #   @return [Integer] church's id
  #   @see Church

  # @!attribute manager_id
  #   @return [Integer] managers's id
  #   @see User

  attr_accessible :church_id, :manager_id
  belongs_to :church
  belongs_to :manager, class_name: "User"
end
