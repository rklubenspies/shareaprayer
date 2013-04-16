# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    processor_uid "test-plan"
    member_limit 50
    name "Test Plan"
    description "For testing only"
  end
end
