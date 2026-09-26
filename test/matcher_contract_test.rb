require "minitest/autorun"
require "minitest/matchers_vaccine"

class MatcherContractTest < Minitest::Test
  class ModernMatcher
    attr_reader :calls

    def initialize(result)
      @result = result
      @calls = []
    end

    def matches?(subject)
      @calls << [:matches?, subject]
      @subject = subject
      @result
    end

    def failure_message
      @calls << :failure_message
      "expected #{@subject.inspect} to match"
    end

    def failure_message_when_negated
      @calls << :failure_message_when_negated
      "expected #{@subject.inspect} not to match"
    end
  end

  class RSpec2Matcher < ModernMatcher
    alias_method :failure_message_for_should, :failure_message
    alias_method :failure_message_for_should_not, :failure_message_when_negated
    undef_method :failure_message, :failure_message_when_negated
  end

  class RSpec1Matcher < ModernMatcher
    alias_method :negative_failure_message, :failure_message_when_negated
    undef_method :failure_message_when_negated
  end

  class NegatedMatcher < ModernMatcher
    def matches?(subject)
      raise "matches? must not be called when does_not_match? is available"
    end

    def does_not_match?(subject)
      @calls << [:does_not_match?, subject]
      @subject = subject
      @result
    end
  end

  [ModernMatcher, RSpec2Matcher, RSpec1Matcher, NegatedMatcher].each do |matcher_class|
    assertions = matcher_class == NegatedMatcher ? [:assert_wont] : [:assert_must, :assert_wont]

    assertions.each do |assertion|
      name = "#{matcher_class.name.split('::').last}_#{assertion}"
      predicate = matcher_class == NegatedMatcher ? :does_not_match? : :matches?
      passing_result = assertion == :assert_must || predicate == :does_not_match?
      message_method = assertion == :assert_must ? :failure_message : :failure_message_when_negated
      expected_message = assertion == :assert_must ? "expected :actual to match." : "expected :actual not to match."

      define_method("test_#{name}_does_not_generate_messages_on_success") do
        matcher = matcher_class.new(passing_result)
        target = Minitest::Test.new("matcher contract")

        target.public_send(assertion, matcher, :actual)

        assert_equal [[predicate, :actual]], matcher.calls
        assert_equal 1, target.assertions
      end

      define_method("test_#{name}_generates_message_after_matching") do
        matcher = matcher_class.new(!passing_result)
        target = Minitest::Test.new("matcher contract")

        error = assert_raises(Minitest::Assertion) do
          target.public_send(assertion, matcher, :actual)
        end

        assert_equal expected_message, error.message
        assert_equal [[predicate, :actual], message_method], matcher.calls
        assert_equal 1, target.assertions
      end

      define_method("test_#{name}_includes_custom_message") do
        matcher = matcher_class.new(!passing_result)

        error = assert_raises(Minitest::Assertion) do
          public_send(assertion, matcher, :actual, "custom context")
        end

        assert_equal "custom context.\n#{expected_message}", error.message
      end
    end
  end

  def test_modern_positive_message_takes_precedence_over_legacy_message
    matcher = ModernMatcher.new(false)
    def matcher.failure_message_for_should
      raise "legacy positive message must not be used"
    end

    error = assert_raises(Minitest::Assertion) { assert_must(matcher, :actual) }

    assert_equal "expected :actual to match.", error.message
  end

  def test_modern_negative_message_takes_precedence_over_legacy_messages
    matcher = ModernMatcher.new(true)
    def matcher.failure_message_for_should_not
      raise "RSpec 2 negative message must not be used"
    end
    def matcher.negative_failure_message
      raise "RSpec 1 negative message must not be used"
    end

    error = assert_raises(Minitest::Assertion) { assert_wont(matcher, :actual) }

    assert_equal "expected :actual not to match.", error.message
  end

  def test_rspec2_negative_message_takes_precedence_over_rspec1_message
    matcher = RSpec2Matcher.new(true)
    def matcher.negative_failure_message
      raise "RSpec 1 negative message must not be used"
    end

    error = assert_raises(Minitest::Assertion) { assert_wont(matcher, :actual) }

    assert_equal "expected :actual not to match.", error.message
  end

  [:must, :wont].each do |assertion|
    define_method("test_#{assertion}_uses_instance_subject_and_counts_one_assertion") do
      @subject = :implicit
      matcher = ModernMatcher.new(assertion == :must)
      previous_assertions = self.assertions

      public_send(assertion, matcher)

      assert_equal previous_assertions + 1, self.assertions
      assert_equal [[:matches?, :implicit]], matcher.calls
    end

    define_method("test_#{assertion}_forwards_custom_message_and_counts_one_failed_assertion") do
      target = Minitest::Test.new("matcher contract")
      matcher = ModernMatcher.new(assertion != :must)
      expected_message = assertion == :must ? "expected :actual to match." : "expected :actual not to match."

      error = assert_raises(Minitest::Assertion) do
        target.public_send(assertion, matcher, :actual, "custom context")
      end

      assert_equal "custom context.\n#{expected_message}", error.message
      assert_equal 1, target.assertions
    end
  end
end
