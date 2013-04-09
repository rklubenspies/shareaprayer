# Stores churchs' profiles
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchProfile < ActiveRecord::Base
  attr_accessible :address, :bio, :email, :phone, :website
  belongs_to :church
end
