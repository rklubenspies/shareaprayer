FactoryGirl.define do
  sequence :email do |n|
    "test-email-#{n}@shareaprayer.org"
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    email
    provider "facebook"
    provider_uid "100000000000000"
    facebook_token "abcdefg"
    facebook_token_expires_at { Time.now }

    after(:create) do |user|
      user.add_role("site_user")
    end
  end

  factory :invisible_user, class: "User" do
    first_name "Invisible"
    last_name "Joe"
    email
    provider "facebook"
    provider_uid "100000000000000"
    facebook_token "abcdefg"
    facebook_token_expires_at { Time.now }

    after(:create) do |user|
      user.add_role("invisible_user")
    end
  end
end
