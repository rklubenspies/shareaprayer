# Changelog

## 0.1.4 (August 16, 2011)
#### Authors
Robert Klubenspies

#### Bug fixes
*	Profile pictures on Group pages do not render.

#### Features
*	Added "Settings" link to top right of logged in header. 

## 0.1.3 (August 15, 2011)
*This is an emergency release. It adds Google Analytics tracking code which was needed immediately for statistical reasons.*
#### Authors
Robert Klubenspies

#### Features
* **EMERGENCY:** Added Google Analytics tracking code to application layout.

## 0.1.2 (August 15, 2011)
*This is an emergency release. It fixes a bug that gave users with the "admin" role no permissions on the site.*
#### Authors
Robert Klubenspies

#### Bug fixes
*	**EMERGENCY:** No "admin" role in Ability class causes users with the "admin" role to have no permissions on the site.

#### Features
* Updated README to reflect invites dashboard (Added in 0.1.1).

## 0.1.1 (August 15, 2011)
#### Authors
Robert Klubenspies

#### Bug fixes
*	"Please post as my Facebook status" option on dashboard still shows if Facebook authentication is not present.
*	Pictures (generic/default profile picture, icons, etc.) do not render on Heroku.
* Disqus comments not loading because it is still in development mode and keys are not added.

#### Features
*	Remove un-needed tests.
*	Regex based validation for screennames.
*	Change "Destroy" links to say "Delete".
* Invitation dashboard (accessible to admins only) for adding invites and approving people on the wait list to receive invites.

## 0.1.0 (August 14, 2011)
#### Authors
Robert Klubenspies

#### Features
Share a Prayer is created with basic invite system, single group per member, and all prayer sharing capabilities.