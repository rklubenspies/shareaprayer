# Welcome to Share a Prayer

Share a Prayer is a Ruby on Rails 3.1 powered web application. Share a Prayer provides an unique way for users of all religions to send post prayer requests in a microblogging environment.

This is the RoR code for Share a Prayer's web application. We have open sourced our code in hopes that it may help others learn Rails. Please see the COPYING file for more usage information.


## Getting Started

Here's a rough breakdown of how the application is organized:

### Models

#### Ability
Handles authorization through CanCan.

#### Authentication
Stores authentication information for single sign in services like Facebook.

#### Group
Each User may belong to one Group with whom they may share prayer requests.

#### Invite
Stores invite codes which can each be used one time to create an account.

#### Prayer
Stores prayer requests. Each prayer request belongs to a User and (optionally) a Group.

#### Profile
Store profile information for a single User.

#### User
Stores the core user login information with the help of Devise.

#### Waitlist
Store the email addresses of individuals who would like an invite to register an account.

### Controllers

#### Application
Holds core application logic, as usual.

#### Authentications
Contains logic for single sign on and managing your linked sign sign on accounts.

#### Dashboard
Contains logic for powered a logged-in user's dashboard.

#### Groups
Restful resource for groups.

#### Home
Displays the homepage for users who are not logged in.

#### Invites
Handles redemption of invites.

#### Legal
Contains static pages with legal copy such as the Terms of Service and Privacy Policy.

#### Prayers
Restful resource for prayers. Handles mainly permalinking.

#### Registrations
Modified Devise registrations controller. Used to enable single sign on and require an invite code before registration.

#### Settings
Used to display the settings page for editing your profile.

#### Users
Resource for users, mainly used to display profile page.

#### Waitlists
Used to create new Waitlist objects.

### Helpers

#### Application
Used for core application helpers.

## Bugs & Fixes

### Bugs

If you find a bug please report it to this repository's Github Issues Tracker.

### Fixes

If you've fixed a bug, please submit a pull request to this repository with a detailed explanation of what you fixed. Also be sure to add your name and email address to the CONTRIBUTORS file in the format of `Foo Bar <foo.bar@example.com>` if you would like recognition as a contributor.

## License

Please see the COPYING file.

## Authors

Please see the AUTHORS file.

## Contributors

Please see the CONTRIBUTORS files.

## Copyright

Share a Prayer is Copyright (C) 2011 Robert Klubenspies. All rights reserved.