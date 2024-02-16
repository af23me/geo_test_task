# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include WebMockHelper
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
