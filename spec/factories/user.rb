FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "johndoe@shareaprayer.com"

    after(:create) do |user|
      user.add_role("site_user")
    end
  end

  factory :invisible_user, class: "User" do
    name "Invisible Joe"
    email "invisiblejoe@shareaprayer.com"

    after(:create) do |user|
      user.add_role("invisible_user")
    end
  end
end
