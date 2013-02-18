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

  attr_accessible :text, :anonymous
  belongs_to :user
  belongs_to :church
  has_many :prayers, dependent: :destroy
  has_many :reports, as: :reportable, class_name: "ReportedContent", dependent: :destroy

  validates :text, presence: true
  validates :user_id, presence: true

  state_machine :state, initial: :visible do
    # TODO: Implement events to change state
  end
end
