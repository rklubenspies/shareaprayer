# Processes Braintree Webhooks
# 
# @since 1.0.0
# @author Robert Klubenspies
class Api::BraintreeController < Api::ApplicationController
  def webhook
    webhook = Braintree::WebhookNotification.parse(
      params[:bt_signature], params[:bt_payload]
    )

    subscription = Subscription.where(processor_subscription: webhook.subscription.id).first

    case webhook.kind
    when "subscription_went_active"
      subscription.activated!
      render nothing: true, status: 200
    when "subscription_went_past_due"
      subscription.went_past_due!
      render nothing: true, status: 200
    when "subscription_canceled"
      subscription.canceled!
      render nothing: true, status: 200
    else
      render nothing: true, status: 500
    end
  end

  def verify
    render text: Braintree::WebhookNotification.verify(params[:bt_challenge]), :content_type => Mime::TEXT
  end
end