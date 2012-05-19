# The Email model stores an entry for each user's email address. Email addresses are stored here to give us an entry to associate prayer requests with.
# 
# @since 0.1.0
# @author Robert Klubenspies
class Prayer
  # Inlcude Mongoid's Document class and created timestamp
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  # @return [String] name the author name to be displayed with the prayer request
  field :name, type: String
  
  # @return [String] request the full text of the prayer request
  field :request, type: String
  
  # @return [String] ip_address the IP address from which the prayer request was posted
  field :ip_address, type: String
  
  # @return [Integer] time_prayed_for the number of times that the prayer request was prayed for
  field :times_prayed_for, type: Integer, default: 0
  
  # @return [Integer] reported the number of times that the prayer request was reported
  field :reported, type: Integer, default: 0
  
  # @return [String] location the plain-English location (city, state, country, etc.) that a request was posted with
  field :location, type: String
  
  # Protect the id and times_prayed_for from being mass assigned
  attr_protected :id, :times_prayed_for
  
  # Validate the the request is no more than 160 characters and present and that the name is present
  validates_presence_of :request, :name
  validates_length_of :request, maximum: 160
  
  # A Prayer (prayer request) belongs_to an Email (email address entry)
  belongs_to :email
  
  # Finds up to 10 prayer requests in descending order that are older than a given timestamp
  # 
  # @param last the timestamp to query based on
  # @return [Array] an array of up to 10 prayer requests
  # @since 0.1.0
  # @author Robert Klubenspies
  def self.feed(last)
    self.all.where(:created_at.lt => last).desc(:created_at).limit(10).entries
  end
end