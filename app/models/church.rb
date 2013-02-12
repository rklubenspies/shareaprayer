# Stores churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Church < ActiveRecord::Base
  # @!attribute name
  #   @return [String] the church's name

  attr_accessible :name
  has_many :church_memberships, dependent: :destroy
  has_many :users, through: :church_memberships
  has_many :requests
end
