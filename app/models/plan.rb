# Acts as a delegate between Braintree and SAP to remember what
# plans are being sold
# 
# @since 1.0.0
# @author Robert Klubenspies
class Plan < ActiveRecord::Base
  attr_protected :description, :member_limit, :name, :processor_uid

  has_many :vip_signups
  has_many :subscriptions

  # Sets up a new plan at SAP. Requires that the plan is already created
  # at Braintree in order for everything else to function correctly.
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] opts the data about the plan
  # @option opts [String] :processor_uid the id of the plan at Braintree.
  #   Usually in the format of "#{member_limit}-members"
  # @option opts [Integer] :member_limit the maximum number of members a
  #   church is allowed to have under this plan
  # @option opts [String] :name the name of the plan
  # @option opts [String] :description the description of the plan
  # @raise [CouldNotSavePlan] if something goes horribly wrong
  # @return [Plan]
  def self.setup(opts)
    plan = Plan.new
    plan.processor_uid = opts[:processor_uid]
    plan.member_limit = opts[:member_limit]
    plan.name = opts[:name]
    plan.description = opts[:description]
    
    if plan.save
      plan
    else
      raise CouldNotSavePlan
    end
  end
end
