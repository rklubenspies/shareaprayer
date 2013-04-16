FactoryGirl.define do
  sequence :subdomain do |n|
    "testchurch#{n}"
  end

  factory :church do
    name "First Christian Church"
    subdomain
    association :profile, factory: :church_profile
  end
end
