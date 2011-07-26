class Prayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_presence_of :prayer, :source
  validates_length_of :prayer, :in => 1..160
  validates_length_of :source, :maximum => 30
end
