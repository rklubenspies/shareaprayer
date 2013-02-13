user1 = User.create({
  name: "John Doe",
  email: "johndoe@shareaprayer.com",
  roles: ["user"]
})

church = Church.create({
  name: "First Christian Church"
})

user1_church_membership = user1.join_church(church.id)

public_request_1 = user1.post_request({
  text: "Lorem ipsum public dolor"
})

church_request_1 = user1.post_request({
  text: "Lorem ipsum church dolor"
}, church.id)


user2 = User.create({
  name: "Jane Doe",
  email: "janedoe@shareaprayer.com",
  roles: ["invisble"]
})

user2_report = user2.report_object(public_request_1)
