source 'https://rubygems.org'
ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Platform
gem 'rails', '~> 5.0.3'
gem 'pg'
gem 'puma', '~> 3.0'

# Assets
gem 'jquery-rails'
gem 'coffee-rails'
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'font-awesome-rails'
gem 'carmen-rails', '~> 1.0.0'
gem 'popper_js', '~> 1.9.9'
gem 'jt-rails-address', '~> 1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'devise'
gem 'ice_cube'
gem 'phonelib'
gem 'mainstreet'#, github: 'robhurring/address-validator'

# Maybes
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

gem 'factory_girl_rails', '~> 4.8'
gem 'active_record_query_trace'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'pry'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails', '~> 3.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
