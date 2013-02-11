# Represents a user's membership in a church
# 
# @since 1.0.0
# @author Robert Klubenspies
class ChurchMembership < ActiveRecord::Base
  # @!attribute church_id
  #   @return [Integer] church's id
  #   @see Church

  # @!attribute user_id
  #   @return [Integer] user's id
  #   @see User

  # @!attribute roles
  #   @return [Array] representation of user's roles in church they
  #     are a member of
  #   @note Used by easy_role gem
  #   @see https://github.com/platform45/easy_roles easy_roles gem
  #     documentation

  attr_accessible :church_id, :roles, :user_id
  easy_roles :roles
  belongs_to :church
  belongs_to :user

  # @comment This enforces a default role of "member" on all entries
  #   created without roles. We couldn't set the default in the migration
  #   because roles are saved as a String, but adding a role creates a
  #   String representation of an Array to be saved to the database.
  before_validation(on: :create) do
    self.roles = ["member"] if !attribute_present?("roles")
  end
end
