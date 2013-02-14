FactoryGirl.define do
  factory :church_membership do
    user
    church

    after(:create) do |church_membership|
      church_membership.user.add_role(:church_member, church_membership)
    end
  end
end
