FactoryGirl.define do
  factory :request do
    text "Lorem ipsum"
    user_id { FactoryGirl.create(:user).id }
    church_id { FactoryGirl.create(:church).id }
    visibility ["visible"]
    anonymous false
    ip_address "127.0.0.1"
    user
  end

  factory :post_request_opts, class: "Request" do
    text "Lorem ipsum"
    ip_address "127.0.0.1"
  end
end
