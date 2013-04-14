# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    plan_id 1
    church_id 1
    processor_customer "MyString"
    processor_subscription "MyString"
    state "MyString"
  end
end
