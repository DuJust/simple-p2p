if ENV['COV'] == 'true'
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'ffaker'
require 'shoulda-matchers'
require 'simplecov'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path               = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_run_excluding wip: true

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseRewinder.clean_all
  end

  config.after do
    DatabaseRewinder.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
    with.library :action_controller
  end
end
