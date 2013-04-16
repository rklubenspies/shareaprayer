# Stores churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Church < ActiveRecord::Base
  include PgSearch
  extend FriendlyId

  attr_accessible :name, :subdomain, :profile, :subscription, :vip_signup_id,
                  :profile_picture, :remove_profile_picture

  before_destroy :cancel_on_destroy

  friendly_id :subdomain
  mount_uploader :profile_picture, ChurchProfilePictureUploader

  has_one :profile, dependent: :destroy, class_name: "ChurchProfile"
  has_one :subscription, dependent: :destroy
  has_many :church_memberships, dependent: :destroy
  has_many :members, through: :church_memberships, source: :user, class_name: "User"
  has_many :church_managerships, dependent: :destroy
  has_many :managers, through: :church_managerships, source: :user, class_name: "User"
  has_many :requests
  belongs_to :vip_signup

  validates :name, presence: true
  validates :subdomain, presence: true
  validates_format_of :subdomain, with: /^[a-z0-9_]+$/, message: "must be lowercase alphanumerics only"
  validates_length_of :subdomain, maximum: 32, message: "exceeds maximum of 32 characters"
  validates_exclusion_of :subdomain, in: ['www', 'mail', 'api', 'live', 'assets', 'radiation'], message: "is not available"

  pg_search_scope :search_name_and_subdomain,
                  :against => {
                    :name => 'A',
                    :subdomain => 'B'
                  },
                  :using => {
                    :tsearch => { :dictionary => "english" }
                  }

  # Adds a manager to a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] user_id the id of the user being added as manager
  # @return [ChurchManagership] the newly created ChurchManagership object
  # @raise [UserNotSignedUp] if the user is not a signed up user
  # @raise [UserNotChurchMember] if the user is not a member of the church
  #   they're trying to manager
  # @raise [UserAlreadyChurchManager] if the user is already a manager of that
  #   church
  def add_manager(user_id)
    church = self
    user = User.find(user_id)

    raise "UserNotSignedUp" if !user.has_role?("site_user")
    raise "UserNotChurchMember" if !ChurchMembership.where(user_id: user.id, church_id: church.id).exists?
    raise "UserAlreadyChurchManager" if ChurchManagership.where(user_id: user.id, church_id: church.id).exists?

    church.managers << user
  end

  # Removes a manager from a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] user_id the id of the user being removed as manager
  # @return [Boolean] success of transaction
  # @raise [UserNotChurchManager] if the user is not a manager of the church
  def remove_manager!(user_id)
    church = self
    managership = ChurchManagership.where(user_id: user_id, church_id: church.id)

    raise "UserNotChurchManager" if !managership.exists?

    # @comment return true or false instead of deleted object
    managership.destroy_all ? true : false
  end

  # Registers a new church in the system
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] opts the options to register a church with
  # @option opts [String] :name the name of the church
  # @option opts [String] :subdomain the church's subdomain
  # @option opts [String] :profile_picture the church's profile picture
  #   upload form content
  # @option opts [Integer] :vip_signup_id the church's associated VIP
  #   object
  # @option opts [String] :bio the church's bio
  # @option opts [String] :address the church's address
  # @option opts [String] :phone the church's phone number
  # @option opts [String] :email the church's email address
  # @option opts [String] :website the church's website
  # @param [Integer] user_id the id of the first manager of the church
  # @return [Church] the Church object created by the method
  # @raise [UserDoesNotExist] if the user_id does not represent a valid
  #   user
  # @raise [UserNotSignedUp] if the user_id represents a user which is
  #   not a site user
  def self.register(opts = {}, user_id)
    user = User.find(user_id)

    raise "UserNotSignedUp" if !user.has_role?("site_user")

    church = Church.create({
      name:             opts[:name],
      subdomain:        opts[:subdomain],
      profile_picture:  opts[:profile_picture],
      vip_signup_id:    opts[:vip_signup_id],
    })

    church_profile_opts = {
      bio:        opts[:bio],
      address:    opts[:address],
      phone:      opts[:phone],
      email:      opts[:email],
      website:    opts[:website],
    }
    church.profile = ChurchProfile.create(church_profile_opts)

    user.join_church(church.id)
    church.add_manager(user.id)

    church
  end

  # Updated a church's profile
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @note Passing ANY nil values WILL result in that attribute being
  #   set to nil!
  # @param [Hash] opts the attributes to update
  # @option opts [String] :name the name of the church
  # @option opts [String] :bio the church's bio
  # @option opts [String] :address the church's address
  # @option opts [String] :profile_picture the upload form data for
  #   a profile picture
  # @option opts [Boolean] :remove_profile_picture remove a profile
  #   picture
  # @option opts [String] :phone the church's phone number
  # @option opts [String] :website the church's website
  # @return [Boolean] success of transaction
  def update_data!(opts)
    church = self
    profile = self.profile
    church_opts = {}
    profile_opts = {}

    church_opts["name"] = opts["name"]

    if !opts["profile_picture"].blank?
      church_opts["profile_picture"] = opts["profile_picture"]
    end

    if opts["remove_profile_picture"] == "1"
      church_opts["remove_profile_picture"] = true
    end

    profile_opts["bio"] = opts["bio"]
    profile_opts["address"] = opts["address"]
    profile_opts["phone"] = opts["phone"]
    profile_opts["website"] = opts["website"]

    church.update_attributes(church_opts) && profile.update_attributes(profile_opts)
  end

  # Creates a customer at Braintree from user and payment data
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] user_id the ID of the user creating and
  #   paying for the Church
  # @param [Hash] payment the secured payment information
  # @option data [String] :number
  # @option data [String] :expiration_month
  # @option data [String] :expiration_year
  # @option data [String] :cvv
  # @raise [CouldNotCreateBraintreeCustomer] if the Braintree customer
  #   with payment information could not be created successfully
  # @return [String] the customer id at Braintree
  def setup_braintree_customer(user_id, payment)
    church = self
    user = User.find(user_id)

    result = Braintree::Customer.create(
      id:           "church-#{church.id}",
      first_name:   user.first_name,
      last_name:    user.last_name,
      company:      church.name,
      email:        user.email,
      credit_card:  {
        cardholder_name:    payment[:name_on_card],
        number:             payment[:number],
        expiration_month:   payment[:expiration_month],
        expiration_year:    payment[:expiration_year],
        cvv:                payment[:cvv],
      }
    )

    if result.success?
      return result.customer.id
    else
      puts result.errors
      raise "CouldNotCreateBraintreeCustomer"
    end
  end

  # Cancels stuff when a church is being destroyed
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def cancel_on_destroy
    self.subscription.cancel_at_braintree!
  end
end
