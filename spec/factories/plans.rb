# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    processor_uid "MyString"
    member_limit 1
    name "MyString"
    description "MyString"
  end
end
