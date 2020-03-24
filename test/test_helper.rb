ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

Mongoid.purge!
Rails.application.load_seed

class ActiveSupport::TestCase
end
