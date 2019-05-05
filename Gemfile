source 'https://rubygems.org'
ruby '2.5.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Platform
gem 'rails', '~> 5.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.12'

# Assets
gem 'jquery-rails', '~> 4.3'
gem 'coffee-rails', '~> 4.2'
gem 'bootstrap', '~> 4.3.1'
gem 'uglifier', '>= 1.3.0'
gem 'font-awesome-rails', '~> 4.7'
gem 'carmen-rails', '~> 1.0.0'
gem 'jt-rails-address', '~> 1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'devise', '~> 4.6'
gem 'ice_cube', '~> 0.16'
gem 'phonelib', '~> 0.6'
gem 'mainstreet', '~> 0.1'
gem 'will_paginate', '~> 3.1'
gem 'state_machines-activerecord', '~> 0.5'

gem 'sendgrid-ruby', '~> 5.0'

# Maybes
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

gem 'factory_bot_rails', '~> 4.8'
# gem 'active_record_query_trace'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'pry'
  gem 'letter_opener', github: 'ryanb/letter_opener'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails', '~> 3.8'
end
