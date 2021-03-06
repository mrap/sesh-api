# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  # Json Helper
  config.include Requests::JsonHelpers, type: :request

  # Paperclip Helper, use like this:
  # stub_paperclip(Model)
  # http://www.awesomeprogrammer.com/blog/2012/08/24/stubbing-paperclip-file-upload-with-rspec/
  config.extend PaperclipMacros

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # mongoid-rspec
  config.include Mongoid::Matchers, type: :model

  # Factory Girl Syntax:
  # i.e. create(:user)
  config.include FactoryGirl::Syntax::Methods

  # Database Cleaner
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.after(:suite) do
    # removes /public/test/
    FileUtils.rm_rf(Dir["#{Rails.root}/public/test"])
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
