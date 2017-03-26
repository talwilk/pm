ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'email_spec'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

# Default per page constant for tests
Object.send(:remove_const, :DEFAULT_PER_PAGE) if defined?(:DEFAULT_PER_PAGE)
Object.send(:const_set, :DEFAULT_PER_PAGE, 4)

# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join("spec/support/**/base.rb")].each { |f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    debug: false,
    :window_size  => [1280, 1440],
    js_errors:          false,
    timeout:            180,
    phantomjs_logger:   File.open(Rails.root.join('log', 'test-js.log'), 'a'),
    phantomjs:          Phantomjs.path,
    phantomjs_options:  ['--load-images=no', '--ignore-ssl-errors=yes']
  })
end

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.

ActiveRecord::Migration.maintain_test_schema!

#ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
#ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    Country.create(country_iso: "PL", enabled_at: Time.zone.now)
    Country.create(country_iso: "RD", enabled_at: Time.zone.now)
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
  config.include FeatureHelpers, :type => :feature
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include OmniauthTestHelper
  config.include ActiveSupport::Testing::TimeHelpers
end
