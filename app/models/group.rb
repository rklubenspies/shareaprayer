class Group < ActiveRecord::Base
  has_many :prayer
  has_many :user
  has_friendly_id :name, :use_slug => true
end
