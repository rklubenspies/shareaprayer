user1 = User.create({
  first_name: "John",
  last_name: "Doe",
  email: "johndoe@shareaprayer.com",
  facebook_id: 100000000000000,
  facebook_token: "abcdefg",
  facebook_token_expires_at: Time.now
})
user1.add_role("site_user")

church = Church.register({
  name: "First Christian Church",
  bio: "Lorem ipsum",
  address: "100 Main Street, Fake Town, FL",
  phone: "4075550525",
  email: "contact@firstchrisitanchurch.com",
  website: "www.firstchrisitanchurch.com"
}, user1.id)

church_request = user1.post_request({
  text: "Lorem ipsum church dolor"
}, church.id)


user2 = User.create({
  first_name: "Jane",
  last_name: "Doe",
  email: "janedoe@shareaprayer.com",
  facebook_id: 100000000000001,
  facebook_token: "abcdefg",
  facebook_token_expires_at: Time.now
})
user2.add_role("site_user")

user2_report = user2.report_object(church_request)
