FactoryGirl.define do
  factory :church do
    association :profile, factory: :church_profile
  end
end
