user1 = User.create({
  name: "John Doe",
  email: "johndoe@shareaprayer.com"
})
user1.add_role("site_user")

church = Church.register({
  name: "First Christian Church"
}, user1.id)

church_request = user1.post_request({
  text: "Lorem ipsum church dolor"
}, church.id)


user2 = User.create({
  name: "Jane Doe",
  email: "janedoe@shareaprayer.com"
})
user2.add_role("site_user")

user2_report = user2.report_object(church_request)
