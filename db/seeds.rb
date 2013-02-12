user = User.create({
  name: "John Doe",
  email: "johndoe@shareaprayer.com",
  roles: ["invisible"]
})

church = Church.create({
  name: "First Christian Church"
})

users_church_membership = ChurchMembership.create({
  user_id: user.id,
  church_id: church.id,
  roles: ["member"]
})

public_request = user.post_request({
  text: "Lorem ipsum public dolor"
})

church_request = user.post_request({
  text: "Lorem ipsum church dolor"
}, church.id)