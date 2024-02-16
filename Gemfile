# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.3'

gem 'dotenv-rails', '~> 2.8'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors', '~> 2.0.1'

gem 'active_model_serializers', '~> 0.10.13'
gem 'httparty', '~> 0.21.0'
gem 'rswag-api', '~> 2.13.0'
gem 'rswag-ui', '~> 2.13.0'

group :development, :test do
  gem 'byebug', '~> 11.1.3'
  gem 'factory_bot', '~> 6.3'
  gem 'faker',       '~> 3.2'
  gem 'rspec-rails', '~> 6.0'
  gem 'rswag-specs', '~> 2.13.0'
  gem 'rubocop', '~> 1.48.1', require: false
  gem 'rubocop-rails', '~> 2.18.0', require: false
  gem 'rubocop-rspec', '~> 2.18.1', require: false
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.1.0'
  gem 'webmock', '~> 3.19.1'
end
