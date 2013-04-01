# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vip_signup do
    code "0000"
    rep_uid "1"
    name "FCC Kissimee"
    subdomain "fcckissimee"
    bio "Sed auctor neque eu tellus rhoncus ut eleifend nibh porttitor."
    address "500 W Main Street, Kissimee, FL"
    phone "(555) 555-5555"
    website "fcckissimmee.org"
  end
end
