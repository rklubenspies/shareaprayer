source 'http://rubygems.org'

# Rails
gem 'rails', '3.1.3'
gem 'sass-rails',   '~> 3.1.5'

# MongoDB
gem 'bson_ext'
gem 'mongoid', '>= 2.0.0.beta.19'

# AWS
gem 'aws-sdk'

# Layout & UI
gem 'haml', '>= 3.0.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'gritter', '1.0.0'

# Mobile Web App
gem 'jquery_mobile_rails'
gem 'mobylette'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# Test environment
group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

# Heroku Environment
group :production do
	gem 'pg'
	gem 'execjs'
	gem 'therubyracer'
end