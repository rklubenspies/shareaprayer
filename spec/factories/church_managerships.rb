# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :church_managership do
    user
    church
  end
end
