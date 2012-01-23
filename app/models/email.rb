# The Email model stores an entry for each user's email address. Email addresses are stored here to give us an entry to associate prayer requests with.
# 
# @since 0.1.0
# @author Robert Klubenspies
class Email
  # Inlcude Mongoid's Document class and created timestamp
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  # @return [String] email the email address of the user
  field :email, type: String
  
  # Validate that the email address is a real email address and is present
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_nil: false
  validates_presence_of :email
  
  # An Email (email address entry) has_many Prayers (prayer requests)
  has_many :prayers
end
