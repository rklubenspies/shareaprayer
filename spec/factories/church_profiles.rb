# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :church_profile do
    name "First Christian Church"
    bio "Lorem ipsum"
    address "100 Main Street, Fake Town, FL"
    phone "4075550525"
    email "contact@firstchrisitanchurch.com"
    website "www.firstchrisitanchurch.com"
  end
end
