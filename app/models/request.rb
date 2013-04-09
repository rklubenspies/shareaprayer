# Stores requests
# 
# @since 1.0.0
# @author Robert Klubenspies
class Request < ActiveRecord::Base
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

  # Conveience method to check if request was posted anonymously
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [Boolean] whether the request was posted anonymously
  def anonymous?
    anonymous
  end
end
