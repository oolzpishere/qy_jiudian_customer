source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem "capistrano", "~> 3.11", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'

  gem 'rspec-rails'
  # guard detect chang need gem install rb-fsevent
  gem 'guard-rspec', require: false
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'faker'

  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
  gem 'railroady'

  gem 'tapping_device'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'pg'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails'

gem 'devise'
gem 'devise-i18n'
gem 'cancan' # or cancancan
gem "omniauth-wechat-oauth2", git: "https://github.com/mycolorway/omniauth-wechat-oauth2"

gem "jquery-slick-rails"

gem 'sidekiq'
gem 'sinatra'

gem 'font-awesome-sass', '~> 5.8.1'

gem 'babel-transpiler'

# my engines
gem 'frontend', path: 'components/frontend'
gem 'shared', path: 'components/shared'
gem 'account', path: 'components/account'
gem 'admin', path: 'components/admin'
gem 'product', path: 'components/product'
gem 'pay', path: 'components/pay'

# admin engine
# not need this gem, use info>note>production send sms plan A.
# gem 'send_sms', '~> 0.1.2', git: "https://github.com/oolzpishere/send_sms"
