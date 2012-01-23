# Welcome to the Share a Prayer open-source project

Share a Prayer is a simple, minimalistic way to share prayer requests and pray for others. The brainchild of [Shane Maloy][smaloy] and [Robert Klubenspies][rklubenspies], Share a Prayer started back in the Summer of 2010. A recent influx in interest in the project has sparked active development. The new, redesigned version of Share a Prayer features a bleeding-edge design, an account-less prayer sharing system, and a continuous feed of prayer requests from around the world. We have open-sourced Share a Prayer under the MIT license so that others may learn from it, or help support continuing development.

## Documentation
Share a Prayer uses [YARD][yard] for code documentation. The docs can be found online at [RubyDocs][rubydoc].

## Requirements and Setup

Share a Prayer (SAP) is built on [Rails 3.1][rails] and uses Mongoid for data persistence instead of ActiveRecord. Because of this you will have to have MongoDB running on your development machine before running the SAP Rails app (See Install and Running MongoDB below). You will also need to set certain environmental variables for the application to run correctly (see Environmental Variables below) The requirements to run SAP are:

* [Ruby][ruby] 1.9.2 or higher (we run 1.9.2 for development)
* [RVM][rvm] (we run 1.2.2 for development) *RVM in required because the source includes a .rvmrc file to give SAP it's own gemset entitled "shareaprayer"*
* [MongoDB][mongodb] 2.x or higher (we run 2.0.1 for development)

### Installing and Running MongoDB
If you use the [brew package management system][brew], the quickest way to install MongoDB would be to run: 

	brew update
	brew install mongodb

This will update your homebrew formulas and install MongoDB. We opt to place a file called mongod.sh in our home directory so that we could run mongodb quickly and on demand. The contents of that file are replicated below:

	mongod run --config /usr/local/Cellar/mongodb/2.0.1-x86_64/mongod.conf

That's it! Please note that depending on your OS, the location of the config file may change. This shell was written to run under Mac OS X 10.6.x (Snow Leopard), and providing it's in your home directory, it can be invoked by typing `bash mongod.sh` at console while in your home directory. No matter how you invoke MongoDB, it will have to be running on your system before you can cd into SAP's directory and run `rails server`.

### Environmental Variables
SAP requires that certain environmental variables be in place for development, testing, and production environments. These environmental variables are:

* `AWS_KEY` your Amazon Web Services API Public Key
* `AWS_SECRET` your Amazon Web Services API Secret Key
* `MONGODB_URL` the URL of your production MongoDB. We used MongoHQ for our hosting.

#### Setup for Development and Testing Environments
We've included a nifty initializer `_load_config.rb` that will automagically load all of your environmental variable from a YAML file for development and testing. In order to use it, simply add a YAML file called `keys.yml` to your `config` directory. Don't worry this file is excluded from version control by default. The file should look something like this:

	# For running production test server locally
	production:
	  AWS_KEY: 'AAAABBBBCCCCDDDDEEEE'
	  AWS_SECRET: '1111222233334444555566667777888899990000'
	  MONGODB_URL: 'mongodb://user:password@server_url:port/database'
	
	# For running local development server
	development:
	  AWS_KEY: 'AAAABBBBCCCCDDDDEEEE'
	  AWS_SECRET: '1111222233334444555566667777888899990000'
	
	# For running local testing server
	testing:
	  AWS_KEY: 'AAAABBBBCCCCDDDDEEEE'
	  AWS_SECRET: '1111222233334444555566667777888899990000'

Whenever your run Rails locally this will automatically configure your environmental variables, even if you're testing your app in production on a local staging server!

#### Setup for Production Environments
For real, production server environments you'll need to make the environmental variables `AWS_KEY`, `AWS_SECRET`, and `MONGODB_URL` available through other means. Many people simply export those variables in their bash profile. Alternatively if you deploy to production in Heroku, you can take advantage of their config vars. This would allow you to configure your environmental variables via the Heroku CLI like this:

	heroku config:add AWS_KEY=AAAABBBBCCCCDDDDEEEE AWS_SECRET=1111222233334444555566667777888899990000 MONGODB_URL=mongodb://user:password@server_url:port/database

Either way, you'll need to have the three environmental variables available in the production environment. If other people will not see the source of your clone of SAP, you could use the `keys.yml` file on a real, production server. Just be sure to remove it from `.gitignore` and add the file to version control. **Committing the `keys.yml` file to git is not recommended as it will place your API keys and MongoDB URL under version control.**


## Architecture

Below is a quick and dirty breakdown of how the application is organized, always refer to the [documentation][rubydoc] when in doubt.

### Models

#### Email
Stores email addresses of people who post prayer requests. Each email address has many Prayers.

#### Prayer
Stores prayer requests. Each prayer request belongs to an Email.

### Controllers

#### Application
Holds core application logic, as usual.

#### Prayers
Restful resource for prayers. A path hack on the resource route allows everything to branch off of the root path. Thus making the `prayers_path` equivalent to `/` and the `prayer_path` equivalent to `/:id`. The prayers controller also includes extra resourceful routes for `prayed_for` and `report` resource member actions.

#### Legal
Displays TOS and Privacy policy.

#### Api::V1::Base
Base controller (think of it like a namespaced application controller) for V1 API.

#### Api::V1::Prayers
Prayers API. Features json and xml returns for all prayers (paginated) and an individual prayer request.

### Helpers

#### Application
Used for core application helpers, like the timeago helper for jQuery Timeago compatible HTML5 tags.

### Mailers

#### Prayers
Used to email user the permalink of a new prayer request that they posted.

## Feature Requests

Please make all feature requests as detailed as possible and add them to the [issue tracker][issues]. Please add "[FEATURE]" to the beginning of the issue's title so that we know that you are submitting a feature request and not a bug.

## Bugs & Fixes

### Bugs
If you find a bug please report it to the [issue tracker][issues].

### Fixes
If you've fixed a bug, please submit a pull request to this repository with a detailed explanation of what you fixed. When the pull request is accepted, Github will automatically add your username to the [contributors list][contributors].

## Changelog

Please see the CHANGELOG.md file.

## License

Please see the LICENSE file.

## Contributors

Please see [Github's contributors list][contributors].

## Copyright

Share a Prayer is Copyright (C) 2012 Robert Klubenspies. All rights reserved.

[smaloy]: http://shanemaloy.com/
[rklubenspies]: http://robertklubenspies.com/
[yard]: http://yardoc.org/
[rubydoc]: http://rubydoc.info/github/shareaprayer/shareaprayer/master/frames
[rails]: http://rubyonrails.org/
[ruby]: http://www.ruby-lang.org/
[rvm]: http://beginrescueend.com/
[mongodb]: http://www.mongodb.org/
[brew]: http://mxcl.github.com/homebrew/
[issues]: https://github.com/shareaprayer/shareaprayer/issues
[contributors]: https://github.com/shareaprayer/shareaprayer/contributors