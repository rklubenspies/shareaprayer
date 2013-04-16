require 'spec_helper'

describe Api::BraintreeController do
  context '#verify' do
    let!(:verification_code) { Braintree::WebhookNotification.verify("") }

    subject do
      get :verify
    end

    it 'returns successfully' do
      subject
      response.response_code.should == 200
    end

    it 'returns a verification code' do
      subject
      response.body.should == verification_code
    end
  end

  context '#webhook' do
    let!(:subscription) { FactoryGirl.create :subscription }

    subject do
      post :webhook, bt_signature: braintree_test[0], bt_payload: braintree_test[1]
    end

    context 'Subscription Went Active' do
      let!(:subscription) { FactoryGirl.create :subscription, state: "past_due" }

      let!(:braintree_test) {
        Braintree::WebhookTesting.sample_notification(
          Braintree::WebhookNotification::Kind::SubscriptionWentActive,
          subscription.processor_subscription
        )
      }

      it 'makes the subscription active' do
        subscription.state.should == "past_due"

        subject
        sub = Subscription.where(id: subscription.id).first

        sub.state.should == "active"
        response.response_code.should == 200
      end
    end

    context 'Subscription Past Due' do
      let!(:braintree_test) {
        Braintree::WebhookTesting.sample_notification(
          Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
          subscription.processor_subscription
        )
      }

      it 'marks the subscription past due' do
        subscription.state.should == "active"

        subject
        sub = Subscription.where(id: subscription.id).first

        sub.state.should == "past_due"
        response.response_code.should == 200
      end
    end

    context 'Subscription Canceled' do
      let!(:braintree_test) {
        Braintree::WebhookTesting.sample_notification(
          Braintree::WebhookNotification::Kind::SubscriptionCanceled,
          subscription.processor_subscription
        )
      }

      it 'cancels the subscription' do
        subscription.state.should == "active"

        subject
        sub = Subscription.where(id: subscription.id).first

        sub.state.should == "canceled"
        response.response_code.should == 200
      end
    end
  end
end