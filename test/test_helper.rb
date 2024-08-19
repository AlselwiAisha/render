ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'SecureRandom'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)
    
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    
    # Add more helper methods to be used by all tests here...
    Rails.application.routes.default_url_options[:host] = 'localhost:3001'
    # def encrypt_token
    #   encryptor = ActiveRecord::Encryption::Encryptor.new
    #   encryptor.encrypt(SecureRandom.uuid)
    # end
  end
end
