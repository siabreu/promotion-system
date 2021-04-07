ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'jobs'
  add_filter 'mailers'
end

require_relative "../config/environment"
require "rails/test_help"

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include Warden::Test::Helpers
  include LoginMacros

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  #  FOI para LoginMacros
  # def login_user(user = User.create!(email: 'jane.doe@iugu.com.br', password: '123456'))
  #   login_as user, scope: :user
  # end

  # Adiciona o Fabulous run no teste
  # Minitest.load_plugins
  # Minitest::PrideIO.pride!
end
