class Group < ActiveRecord::Base
  has_many :prayer
  has_many :user
  has_friendly_id :name, :use_slug => true
  
  validates_presence_of :name, :description
  validates_length_of :name, :in => 1..50
  validates_length_of :description, :in => 5..300
end
