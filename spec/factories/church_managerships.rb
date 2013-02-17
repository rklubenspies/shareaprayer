# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :church_managership do
    association :manager, factory: :user
    church
  end
end
