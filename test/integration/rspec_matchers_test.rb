require "minitest/autorun"
require "minitest/matchers_vaccine"
require "rspec/expectations"

class RSpecMatchersTest < Minitest::Test
  include RSpec::Matchers

  def test_assert_must_with_a_value_matcher
    assert_must eq("hello"), "hello"
  end

  def test_assert_wont_with_a_collection_matcher
    assert_wont include(:admin, :owner), [:member]
  end

  def test_must_and_wont_with_an_implicit_subject
    @subject = [:member]

    must include(:member)
    wont include(:admin)
  end

  def test_positive_failure_message
    matcher = eq("expected")

    error = assert_raises(Minitest::Assertion) do
      assert_must matcher, "actual"
    end

    assert_equal "#{matcher.failure_message}.", error.message
  end

  def test_negative_failure_message_with_custom_context
    matcher = eq("hello")

    error = assert_raises(Minitest::Assertion) do
      assert_wont matcher, "hello", "checking the greeting"
    end

    assert_equal "checking the greeting.\n#{matcher.failure_message_when_negated}.", error.message
  end

  def test_matcher_specific_negation_rejects_a_partial_match
    # RSpec's negated include requires every listed value to be absent.
    # Simply inverting matches? would incorrectly pass this assertion.
    matcher = include(:admin, :owner)

    error = assert_raises(Minitest::Assertion) do
      assert_wont matcher, [:admin, :member]
    end

    assert_equal "#{matcher.failure_message_when_negated}.", error.message
  end
end
