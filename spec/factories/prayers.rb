# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prayer do
    ip_address "127.0.0.1"
    user
    request
  end
end
