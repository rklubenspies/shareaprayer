# Stores requests
# 
# @since 1.0.0
# @author Robert Klubenspies
class Request < ActiveRecord::Base
  # @!attribute text
  #   @return [String] the request's full text

  # @!attribute user_id
  #   @return [Integer] user's id
  #   @see User

  # @!attribute church_id
  #   @return [Integer] church's id
  #   @see Church

  # @!attribute visibility
  #   @return [Array] representation of request's visbility accross
  #     all of SAP
  #   @note Used by easy_role gem
  #   @see https://github.com/platform45/easy_roles easy_roles gem
  #     documentation

  # @!attribute anonymous
  #   @return [Boolean] whether or not the user wishes to conceal
  #     their identity. Indicates whether the request was posted
  #     annonymously.

  # @!attribute ip_address
  #   @return [String] the ip address used to post the request

  attr_accessible :text, :visibility, :anonymous
  easy_roles :visibility
  belongs_to :user
  belongs_to :church
  has_many :prayers, dependent: :destroy

  validates :text, presence: true
  validates :user_id, presence: true

  # @comment This enforces a default visibility of "visible" on all
  #   entries created without a visibility. We couldn't set the default
  #   in the migration because visibility is saved as a String, but
  #   adding visibility creates a String representation of an Array to be
  #   saved to the database.
  before_validation(on: :create) do
    self.visibility = ["visible"] if !attribute_present?("visibility")
  end
end
