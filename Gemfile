source 'https://rubygems.org'
ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem "bootstrap-sass", "~> 3.1.1.0"


#**************
# for login and signup
## Devise for authentication
gem "devise", "3.2.2"
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"
gem 'omniauth-twitter'

#**************

##annotate for getting details of the models
gem "annotate"
##for getting haml
gem "haml-rails", "0.5.3"
##To handle the commenting and their threading
gem "acts_as_commentable_with_threading", "1.2.0"
## To make the posts and the comments votable
gem "acts_as_votable", "0.8.0"
## For Pagination
gem "kaminari", "0.15.1"
## Adding bootstrap views to Kaminari pagination
#gem 'bootstrap-kaminari-views'
## To handle tags on the posts
gem "acts-as-taggable-on", "3.0.1"
## To make the selection menus more beautiful
gem "select2-rails"
## To add the font-awesome icons
gem "font-awesome-rails", "4.0.3.1"

## For parsing the urls 
gem "nokogiri", "1.6.1"

#For uploading images and files to S3
gem 'paperclip'
gem 'aws-sdk'

## Captcha
gem "recaptcha", :require => "recaptcha/rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

## Get the size of the images
gem 'fastimage', '1.6.1'

## Active admin
gem 'activeadmin', github: 'gregbell/active_admin'

## Google analytics
gem 'google-analytics-rails'


## For mobile Views
gem 'mobile-fu'

group :production do
  gem 'rails_12factor', '0.0.2'

  ## for new relic monitoring
  gem 'newrelic_rpm'

  ## for serving compressed assets on heroku
  gem 'heroku_rails_deflate'

end


group :development do
  #gem 'sqlite3', '1.3.8'

  # for previewing emails
  gem "letter_opener"

  # running background jobs
  gem "foreman"

  # for better rails console
  gem 'hirb'
end
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Asynchronous processing
#gem 'sidekiq'
gem 'delayed_job_active_record'
gem 'daemons', '~> 1.1.9'

#gem 'sidekiq'
#gem 'delayed_job_active_record'
#gem 'sidekiq'

##redis server
gem 'redis'

## For working with sidekiq
#gem 'sinatra', '>= 1.3.0', :require => nil
#gem 'slim'

#clockwork for scheduling jobs
gem 'clockwork', '~> 0.7.5'

# realtime notification
gem 'pusher', '~> 0.12.0'

# for noitification
gem 'mailboxer'
#for activity stream
gem 'stream-ruby'


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'
gem "unicorn-rails"

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'mysql2'
gem 'pg', '0.15.1'

#For search
gem 'thinking-sphinx', '~> 3.1.0'
gem 'flying-sphinx',   '1.2.0'

# For rich text
gem 'tinymce-rails'

# For Twitter like hash tag
gem 'twitter-text', '~> 1.9.0'

# For friendly Id
gem 'friendly_id', '~> 5.0.0'

#For storing session in db
gem 'activerecord-session_store'

