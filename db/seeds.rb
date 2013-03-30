user1 = User.create({
  first_name: "Robert",
  last_name: "Klubenspies",
  email: "robert.klubenspies@gmail.com",
  provider: "facebook",
  provider_uid: "100000109531535",
})
user1.add_role("site_user")

church = Church.register({
  name: "First Christian Church",
  subdomain: "fccwp",
  bio: "Lorem ipsum",
  address: "100 Main Street, Fake Town, FL",
  phone: "4075550525",
  email: "contact@firstchrisitanchurch.com",
  website: "www.firstchrisitanchurch.com",
}, user1.id)

church_request = user1.post_request({
  text: "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed molestie augue sit amet leo consequat posuere. Vestibulum ante.",
}, church.id)