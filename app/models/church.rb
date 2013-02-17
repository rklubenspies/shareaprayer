# Stores churches
# 
# @since 1.0.0
# @author Robert Klubenspies
class Church < ActiveRecord::Base
  # @!attribute name
  #   @return [String] the church's name

  attr_accessible :name
  has_many :church_memberships, dependent: :destroy
  has_many :users, through: :church_memberships
  has_many :church_managerships, dependent: :destroy
  has_many :managers, through: :church_managerships, class_name: "User"
  has_many :requests

  # Adds a manager to a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] manager_id the id of the user who wants to become a
  #   manager of a particular church
  # @return [ChurchManagership] the newly created ChurchManagership object
  # @raise [UserNotSignedUp] if the user is not a signed up user
  # @raise [UserNotChurchMember] if the user is not a member of the church
  #   they're trying to manager
  # @raise [UserAlreadyChurchManager] if the user is already a manager of that
  #   church
  def add_manager(manager_id)
    church = self
    user = User.find(manager_id)

    raise "UserNotSignedUp" if !user.has_role?("site_user")
    raise "UserNotChurchMember" if !ChurchMembership.where(user_id: user.id, church_id: church.id).exists?
    raise "UserAlreadyChurchManager" if ChurchManagership.where(manager_id: user.id, church_id: church.id).exists?

    church.managers << user
  end

  # Removes a manager from a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is leaving
  # @return [Boolean] success of transaction
  # @raise [UserNotChurchManager] if the user is not a manager of the church
  def remove_manager!(manager_id)
    church = self
    managership = ChurchManagership.where(manager_id: manager_id, church_id: church.id)

    raise "UserNotChurchManager" if !managership.exists?

    # @comment return true or false instead of deleted object
    managership.destroy_all ? true : false
  end
end
