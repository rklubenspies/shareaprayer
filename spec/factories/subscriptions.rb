# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :processor_customer do |n|
    "test-customer-#{n}"
  end

  sequence :processor_subscription do |n|
    "test-subscription-#{n}"
  end

  factory :subscription do
    association :plan, factory: :plan
    association :church, factory: :church
    processor_customer
    processor_subscription
    state "active"
  end
end
