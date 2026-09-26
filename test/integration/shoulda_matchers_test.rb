require "minitest/autorun"
require "minitest/matchers_vaccine"
require "active_model"
require "shoulda-matchers"

class ShouldaMatchersTest < Minitest::Test
  include Shoulda::Matchers::ActiveModel

  class Profile
    include ActiveModel::Model

    attr_accessor :name, :nickname

    validates :name, presence: true
    validates :nickname, length: { maximum: 20 }, allow_blank: true
  end

  def setup
    @subject = Profile.new(name: "Ada")
  end

  def test_assert_must_with_a_validation_matcher
    assert_must validate_presence_of(:name), @subject
  end

  def test_assert_wont_with_a_validation_matcher
    assert_wont validate_presence_of(:nickname), @subject
  end

  def test_must_and_wont_with_an_implicit_subject
    must validate_presence_of(:name)
    wont validate_presence_of(:nickname)
  end

  def test_chained_validation_matcher
    must validate_length_of(:nickname).is_at_most(20)
  end

  def test_positive_failure_message_with_custom_context
    matcher = validate_presence_of(:nickname)

    error = assert_raises(Minitest::Assertion) do
      assert_must matcher, @subject, "checking optional nickname"
    end

    assert_equal "checking optional nickname.\n#{matcher.failure_message}.", error.message
  end

  def test_negative_failure_message
    matcher = validate_presence_of(:name)

    error = assert_raises(Minitest::Assertion) do
      assert_wont matcher, @subject
    end

    assert_equal "#{matcher.failure_message_when_negated}.", error.message
  end
end
