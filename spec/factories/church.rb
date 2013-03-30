FactoryGirl.define do
  sequence :subdomain do |n|
    "test-church-#{n}"
  end

  factory :church do
    subdomain
    association :profile, factory: :church_profile
  end
end
