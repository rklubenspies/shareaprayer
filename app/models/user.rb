# Stores users
# 
# @since 1.0.0
# @author Robert Klubenspies
class User < ActiveRecord::Base
  # @!attribute name
  #   @return [String] user's full name

  # @!attribute email
  #   @return [String] user's email address
  #   @see This is usually provided by Facebook on sign up

  # @!attribute roles
  #   @return [Array] representation of user's roles on SAP
  #   @note Used by easy_role gem
  #   @see https://github.com/platform45/easy_roles easy_roles gem
  #     documentation

  # @!attribute facebook_id
  #   @return [Integer] user's Facebook UID

  # @!attribute facebook_token
  #   @return user's Facebook access token, usually used to verify login
  #     or execute offline Graph API queries

  attr_accessible :name, :email, :roles, :facebook_id, :facebook_token
  easy_roles :roles
  has_many :church_memberships, dependent: :destroy
  has_many :churches, through: :church_memberships

  # @comment This enforces a default role of "invisible" on all entries
  #   created without roles. We couldn't set the default in the migration
  #   because roles are saved as a String, but adding a role creates a
  #   String representation of an Array to be saved to the database.
  before_validation(on: :create) do
    self.roles = ["invisible"] if !attribute_present?("roles")
  end

  # Adds a user as a member of a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is joining
  # @param [Array] roles the roles of the user in the church
  # @return [ChurchMembership] the newly created ChurchMembership object
  # @raise [UserNotSignedUp] if the user is not a signed up user
  # @raise [UserAlreadyChurchMember] if the user already belongs to the church
  def join_church!(church_id, roles = ["member"])
    user = self

    raise "UserNotSignedUp" if !user.roles.include?("user")
    raise "UserAlreadyChurchMember" if ChurchMembership.where(user_id: user.id, church_id: church_id).exists?

    ChurchMembership.create!(user_id: user.id, church_id: church_id, roles: roles)
  end

  # Removes a user as a member of a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is leaving
  # @return [Boolean] success of transaction
  # @raise [UserNotChurchMember] if the user does not belong to the church
  def leave_church!(church_id)
    user = self
    membership = ChurchMembership.where(user_id: user.id, church_id: church_id)

    raise "UserNotChurchMember" if !membership.exists?

    # @comment return true or false instead of deleted object
    membership.destroy_all ? true : false
  end
end
