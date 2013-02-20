FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    email "johndoe@shareaprayer.com"
    facebook_id 100000000000000
    facebook_token "abcdefg"
    facebook_token_expires_at { Time.now }

    after(:create) do |user|
      user.add_role("site_user")
    end
  end

  factory :invisible_user, class: "User" do
    first_name "Invisible"
    last_name "Joe"
    email "invisiblejoe@shareaprayer.com"
    facebook_id 100000000000000
    facebook_token "abcdefg"
    facebook_token_expires_at { Time.now }

    after(:create) do |user|
      user.add_role("invisible_user")
    end
  end
end
