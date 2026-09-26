require "minitest/autorun"
require "minitest/matchers_vaccine"
require "strip_attributes"
require "strip_attributes/matchers"

class StripAttributesMatchersTest < Minitest::Test
  include StripAttributes::Matchers

  class Profile
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    attribute :name, :string
    attribute :password, :string

    strip_attributes only: :name, collapse_spaces: true

    # StripAttributes writes normalized values through the model's []= API.
    def []=(attribute, value)
      public_send("#{attribute}=", value)
    end
  end

  def setup
    @subject = Profile.new
  end

  def test_assert_must_with_a_normalized_attribute
    assert_must strip_attribute(:name), @subject
  end

  def test_assert_wont_with_an_excluded_attribute
    assert_wont strip_attribute(:password), @subject
  end

  def test_must_and_wont_with_an_implicit_subject
    must strip_attribute(:name)
    wont strip_attribute(:password)
  end

  def test_chained_normalization_matcher
    must strip_attribute(:name).collapse_spaces.using("Ada")
  end

  def test_positive_failure_message_with_custom_context
    matcher = strip_attribute(:password)

    error = assert_raises(Minitest::Assertion) do
      assert_must matcher, @subject, "checking preserved whitespace"
    end

    assert_equal "checking preserved whitespace.\n#{matcher.failure_message}.", error.message
  end

  def test_negative_failure_message
    matcher = strip_attribute(:name)

    error = assert_raises(Minitest::Assertion) do
      assert_wont matcher, @subject
    end

    assert_equal "#{matcher.failure_message_when_negated}.", error.message
  end
end
