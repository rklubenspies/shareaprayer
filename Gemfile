source 'http://rubygems.org'

# Core
gem 'rails', '3.1.0.rc4'

# Asset template engines
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

# Misc
gem 'jquery-rails'
gem 'omniauth'
gem 'fbgraph'
gem 'compass', git: 'https://github.com/chriseppstein/compass.git', branch: 'rails31'
gem 'haml'

# Local Environment
group :test do
  # Pretty printed test output
  gem 'turn', :require => false
	gem 'sqlite3'
end

# Heroku Environment
group :production do
	gem 'pg'
	gem 'execjs'
	gem 'therubyracer'
end