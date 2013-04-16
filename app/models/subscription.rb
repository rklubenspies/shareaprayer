# Stores subscription information for a church. Also acts as a delegate
# to Braintree for manipulating subscription information.
# 
# @since 1.0.0
# @author Robert Klubenspies
class Subscription < ActiveRecord::Base
  attr_accessible :state  
  attr_protected :church_id, :plan_id, :processor_customer,
                 :processor_payment_token, :processor_subscription

  belongs_to :church
  belongs_to :plan

  state_machine :state, initial: :active do
    event :activated do
      transition all - [:active] => :active
    end

    event :went_past_due do
      transition :active => :past_due
    end

    event :canceled do
      transition all - [:canceled] => :canceled
    end
  end

  # Setup a new subscription (used by VipSignup)
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the ID of the Church we're creating
  #   a subscription for
  # @param [Integer] plan_id the ID of the plan the Church is
  #   subscribing to
  # @raise [CouldNotSubscribe] if we could not subscribe at
  #   Braintree
  # @return [Subscription]
  def self.setup(church_id, plan_id, braintree_customer_id)
    church        = Church.find(church_id)
    vip_signup    = church.vip_signup
    customer      = Braintree::Customer.find(braintree_customer_id)
    payment_token = customer.credit_cards[0].token
    subscription  = Subscription.new

    subscription.church_id                = church_id
    subscription.plan_id                  = plan_id
    subscription.processor_customer       = braintree_customer_id
    subscription.processor_payment_token  = payment_token

    subscription.save!

    raise "CouldNotSubscribe" unless subscription.subscribe_at_braintree!

    subscription
  end

  # Subscribe user at Braintree and update the subscription ID in
  # our database
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @raise [ErrorCreatingSubscription] if Braintree would not
  #   create subscription
  # @raise [CouldNotActivateSubscription] if we could not change
  #   the Subscription state to active
  # @return [Boolean] whether the user was subscribed successfully
  def subscribe_at_braintree!
    result = Braintree::Subscription.create(
      payment_method_token:   self.processor_payment_token,
      plan_id:                self.plan.processor_uid
    )

    if result.success?
      self.processor_subscription = result.subscription.id
      
      if self.save!
        self.activated!
      else
        raise "CouldNotActivateSubscription"
      end
    else
      raise "ErrorCreatingSubscription"
    end
  end

  # Cancels subscription at Braintree
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @raise [CouldNotCancelBraintreeSubscription] if the Braintree
  #   subscription could not be cancelled
  # @return [Boolean]
  def cancel_at_braintree!
    raise "CouldNotCancelBraintreeSubscription" unless Braintree::Subscription.cancel(self.processor_subscription)
  end
end
