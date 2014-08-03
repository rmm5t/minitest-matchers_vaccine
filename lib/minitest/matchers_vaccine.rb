require "minitest"
require "minitest/matchers_vaccine/version"

# Borrowed and modified from minitest-matchers, but we don't need all the
# other RSpec-style expectation "infections."
module Minitest
  module Assertions
    ##
    # Passes if matcher.matches?(subject) returns true
    #
    # Example:
    #
    #   def test_validations
    #     assert_must be_valid, @user
    #   end
    def assert_must(matcher, subject, msg = nil)
      msg = message(msg) do
        if matcher.respond_to? :failure_message
          matcher.failure_message # RSpec 3.x, 1.1
        else
          matcher.failure_message_for_should # RSpec 2.x, 1.2
        end
      end

      assert matcher.matches?(subject), msg
    end

    ##
    # Facilitator to assert_must for use with minitest-spec. If no subject
    # given, defaults to matching against the current `subject` or the
    # instance variable `@subject`.
    #
    # Example:
    #
    #   subject { Order.new }
    #
    #   it "should have associations" do
    #     must belong_to :account
    #     must have_many :line_items
    #   end
    def must(matcher, subject = @subject || subject, msg = nil)
      assert_must matcher, subject, msg
    end

    ##
    # Passes if matcher.matches?(subject) returns false
    #
    # Example:
    #
    #   def test_validations
    #     assert_wont be_valid, @user
    #   end
    def assert_wont(matcher, subject, msg = nil)
      msg = message(msg) do
        if matcher.respond_to? :failure_message_when_negated # RSpec 3.x
          matcher.failure_message_when_negated # RSpec 3.x
        elsif matcher.respond_to? :failure_message_for_should_not
          matcher.failure_message_for_should_not # RSpec 2.x, 1.2
        else
          matcher.negative_failure_message # RSpec 1.1
        end
      end

      if matcher.respond_to? :does_not_match?
        assert matcher.does_not_match?(subject), msg
      else
        refute matcher.matches?(subject), msg
      end
    end

    ##
    # Facilitator to assert_wont for use with minitest-spec. If no subject
    # given, defaults to matching against the current `subject` or the
    # instance variable `@subject`.
    #
    # Example:
    #
    #   subject { User.new }
    #
    #   it "should validate" do
    #     wont have_valid(:email).when("foo", "foo@bar", "@bar.com")
    #   end
    def wont(matcher, subject = @subject || subject, msg = nil)
      assert_wont matcher, subject, msg
    end
  end
end
