# Stores churchs' profiles
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchProfile < ActiveRecord::Base
  # @!attribute name
  #   @return [String] the name of the church

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

  # @!attribute church_id
  #   @return [String] the id of the church the profile belongs to

  attr_accessible :name, :address, :bio, :email, :phone, :website
  belongs_to :church
end
