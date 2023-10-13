ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mutant/minitest/coverage"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def assert_domain_event(expected, actual)
      assert_equal expected.class, actual.class
      assert_equal expected.deconstruct_keys(nil), actual.deconstruct_keys(nil)
    end
  end
end
