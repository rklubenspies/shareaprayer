class Email
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :email, type: String
    
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_nil: false
  validates_presence_of :email
  
  has_many :prayers
end
