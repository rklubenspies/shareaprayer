FactoryGirl.define do
  factory :church_membership do
    roles ["member"]
    user
    church
  end
end
