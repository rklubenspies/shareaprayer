class Prayer < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :group, :counter_cache => true
  
  validates_presence_of :prayer, :source
  validates_length_of :prayer, :in => 1..160
  validates_length_of :source, :maximum => 30
end
