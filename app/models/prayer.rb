class Prayer
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :name, type: String
  field :request, type: String
  field :ip_address, type: String
  field :times_prayed_for, type: Integer, default: 0
  field :reported, type: Integer, default: 0
  
  attr_protected :id, :times_prayed_for
  
  validates_presence_of :request, :name
  validates_length_of :request, maximum: 160
  
  belongs_to :email
  
  def self.feed(last)
    self.all.where(:created_at.lt => last).desc(:created_at).limit(10).entries
  end
end