# Stores churchs' profiles
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchProfile < ActiveRecord::Base
  # @!attribute church_id
  #   @return [String] the id of the church the profile belongs to

  # @!attribute bio
  #   @return [String] the church's bio

  # @!attribute address
  #   @return [String] the church's address

  # @!attribute email
  #   @return [String] the church's email address

  # @!attribute phone
  #   @return [String] the church's phone number

  # @!attribute website
  #   @return [String] the church's website

  attr_accessible :address, :bio, :email, :phone, :website
  belongs_to :church
end
