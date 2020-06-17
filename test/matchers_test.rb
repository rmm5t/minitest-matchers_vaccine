require "minitest/autorun"
require "minitest/matchers_vaccine"

module InstanceOf
  def be_instance_of klass
    Matcher.new klass
  end

  class Matcher
    def initialize klass
      @klass = klass
    end

    def description
      "be instance of #{@klass}"
    end

    def matches? subject
      @subject = subject
      @subject.instance_of? @klass
    end

    def failure_message
      "expected to " + description
    end

    def failure_message_when_negated
      "expected not to " + description
    end
  end
end

describe "#assert_must" do
  include InstanceOf

  it "should be capable of passing" do
    assert_must(be_instance_of(Array), [:hello])
    assert_must(be_instance_of(String), "hello")
  end

  it "should be capable of failing" do
    assert_raises(Minitest::Assertion) { assert_must(be_instance_of(String), [:hello]) }
    assert_raises(Minitest::Assertion) { assert_must(be_instance_of(Array), "hello") }
  end
end

describe "#assert_wont" do
  include InstanceOf

  it "should be capable of passing" do
    assert_wont(be_instance_of(String), [:hello])
    assert_wont(be_instance_of(Array), "hello")
  end

  it "should be capable of failing" do
    assert_raises(Minitest::Assertion) { assert_wont(be_instance_of(Array), [:hello]) }
    assert_raises(Minitest::Assertion) { assert_wont(be_instance_of(String), "hello") }
  end
end

describe "#must" do
  include InstanceOf

  describe "given a subject" do
    subject { [:hello] }

    it "should be capable of passing" do
      assert must(be_instance_of(Array))
    end

    it "should be capable of failing" do
      assert_raises(Minitest::Assertion) { must be_instance_of String }
    end
  end

  describe "given a @subject" do
    before do
      @subject = "hello"
    end

    it "should be capable of passing" do
      assert must(be_instance_of(String))
    end

    it "should be capable of failing" do
      assert_raises(Minitest::Assertion) { must be_instance_of Array }
    end
  end

  describe "without a subject" do
    it "should error" do
      assert_raises(NoMethodError) { must be_instance_of Array }
    end
  end
end

describe "#wont" do
  include InstanceOf

  describe "given a subject" do
    subject { [:hello] }

    it "should be capable of passing" do
      wont(be_instance_of(String))
    end

    it "should be capable of failing" do
      assert_raises(Minitest::Assertion) { wont be_instance_of Array }
    end
  end

  describe "given a @subject" do
    before do
      @subject = "hello"
    end

    it "should be capable of passing" do
      wont(be_instance_of(Array))
    end

    it "should be capable of failing" do
      assert_raises(Minitest::Assertion) { wont be_instance_of String }
    end
  end

  describe "without a subject" do
    it "should error" do
      assert_raises(NoMethodError) { wont be_instance_of Array }
    end
  end
end
