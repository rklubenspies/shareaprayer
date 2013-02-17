# Stores churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Church < ActiveRecord::Base
  # @!attribute name
  #   @return [String] the church's name

  attr_accessible :name
  has_one :profile, dependent: :destroy, class_name: "ChurchProfile"
  has_many :church_memberships, dependent: :destroy
  has_many :members, through: :church_memberships, source: :user, class_name: "User"
  has_many :church_managerships, dependent: :destroy
  has_many :managers, through: :church_managerships, source: :user, class_name: "User"
  has_many :requests

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

    church_opts = {
      name: opts[:name]
    }

    church = Church.new
    church.name = church_opts[:name]
    church.save!

    church_profile_opts = {
      bio: opts[:bio],
      address: opts[:address],
      phone: opts[:phone],
      email: opts[:email],
      website: opts[:website]
    }

    church.profile = ChurchProfile.create(church_profile_opts)

    user.join_church(church.id)

    church.add_manager(user.id)

    church
  end
end
