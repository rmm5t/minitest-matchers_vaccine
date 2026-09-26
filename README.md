# Minitest::MatchersVaccine

[![Gem Version](http://img.shields.io/gem/v/minitest-matchers_vaccine.svg)](https://rubygems.org/gems/minitest-matchers_vaccine)
[![Build Status](https://github.com/rmm5t/minitest-matchers_vaccine/workflows/CI/badge.svg)](https://github.com/rmm5t/minitest-matchers_vaccine/actions?query=workflow%3ACI)
[![Maintainability](https://api.codeclimate.com/v1/badges/ca7aadb1a0a1c1c6782e/maintainability)](https://codeclimate.com/github/rmm5t/minitest-matchers_vaccine)

Use RSpec-compatible matchers through Minitest assertions, without
expectation-method _infections_ on the objects under test.

Many testing libraries provide useful matchers for validations, associations,
and other behavior. This gem lets you reuse those matchers with `assert_must`,
`assert_wont`, `must`, and `wont` in your Minitest tests. These methods are added
to Minitest's assertions, without adding methods to the objects under test.

**Why not use
[minitest-matchers](https://github.com/wojtekmach/minitest-matchers)?** This
gem is inspired by its matcher assertions and focuses on the four assertion
helpers above.

## Installation

Add this line to your application's Gemfile:

    gem "minitest-matchers_vaccine"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-matchers_vaccine

## Usage

Load the gem in your `test_helper.rb` after Minitest:

```ruby
require "minitest/autorun"
require "minitest/matchers_vaccine"
```

### Runnable example

This example defines its own matcher, so it only needs Minitest and this gem.
Save it as `even_test.rb` and run `bundle exec ruby even_test.rb`:

```ruby
require "minitest/autorun"
require "minitest/matchers_vaccine"

class BeEven
  def matches?(subject)
    @subject = subject
    subject.even?
  end

  def failure_message
    "expected #{@subject.inspect} to be even"
  end

  def failure_message_when_negated
    "expected #{@subject.inspect} not to be even"
  end
end

class EvenTest < Minitest::Test
  def setup
    @subject = 2
  end

  def test_explicit_subjects
    assert_must BeEven.new, 4, "checking the total"
    assert_wont BeEven.new, 3
  end

  def test_subject_helpers
    must BeEven.new
    wont BeEven.new, 3, "checking an odd value"
  end
end
```

### Assertions and subjects

| Assertion | Behavior |
| --- | --- |
| `assert_must(matcher, subject, message = nil)` | Passes when the matcher matches the explicit subject. |
| `assert_wont(matcher, subject, message = nil)` | Passes when the matcher does not match the explicit subject. |
| `must(matcher, subject = ..., message = nil)` | Like `assert_must`, with an optional subject. |
| `wont(matcher, subject = ..., message = nil)` | Like `assert_wont`, with an optional subject. |

`must` and `wont` choose their subject in this order:

1. The explicitly supplied second argument, including `false` or `nil`.
2. The `@subject` instance variable, if defined, including `false` or `nil`.
3. The return value of the `subject` method, such as a Minitest::Spec
   `subject { ... }` declaration.

If no subject is supplied or defined, the call raises `NoMethodError`.

The optional third argument adds a custom message before the matcher's failure
message. To supply a custom message to `must` or `wont`, pass the subject
explicitly as the second argument, as shown above.

### Third-party matchers

Install and configure the libraries that provide your matchers separately:

| Library and setup instructions | Matchers used below |
| --- | --- |
| [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers#minitest) | `have_db_column`, `belong_to`, `have_many` |
| [valid_attribute](https://github.com/bcardarella/valid_attribute#installation) | `have_valid` |
| [strip_attributes](https://github.com/rmm5t/strip_attributes#minitest-matchersvaccine) | `strip_attribute` |

The following application examples assume your test helper loads the gem and
makes those matcher methods available in the test class or spec. They also
assume a `User` model with the corresponding database schema, associations,
validations, and attribute-stripping behavior.

#### Minitest::Test

```ruby
require "test_helper"

class UserTest < Minitest::Test
  def setup
    @subject = User.new
  end

  def test_fields_and_associations
    must have_db_column :name
    must belong_to :account
    assert_must have_many(:widgets), @subject
  end

  def test_validations
    must have_valid(:email).when("a@a.com", "foo@bar.com", "dave@abc.io")
    wont have_valid(:email).when(nil, "foo", "foo@bar", "@bar.com")
  end

  # Works with strip_attributes
  def test_stripping
    assert_must strip_attribute(:name), User.new
  end
end
```

#### Minitest::Spec

```ruby
require "test_helper"

describe User do
  subject { User.new }

  # Works with shoulda-matchers
  it "has fields and associations" do
    must have_db_column :name
    must belong_to :account
    must have_many :widgets
  end

  # Works with valid_attribute
  it "validates" do
    must have_valid(:email).when("a@a.com", "foo@bar.com", "dave@abc.io")
    wont have_valid(:email).when(nil, "foo", "foo@bar", "@bar.com")
  end

  # Works with strip_attributes
  it "strips attributes" do
    must strip_attribute :name
  end
end
```

## Contributing

1. Fork it ( https://github.com/rmm5t/minitest-matchers_vaccine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

The idea was originally inspired by the matcher assertions implementation in
[minitest-matchers](https://github.com/wojtekmach/minitest-matchers).

## License

[MIT License](https://rmm5t.mit-license.org/)
