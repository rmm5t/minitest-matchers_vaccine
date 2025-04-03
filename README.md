# Minitest::MatchersVaccine

[![Gem Version](http://img.shields.io/gem/v/minitest-matchers_vaccine.svg)](https://rubygems.org/gems/minitest-matchers_vaccine)
[![Build Status](https://github.com/rmm5t/minitest-matchers_vaccine/workflows/CI/badge.svg)](https://github.com/rmm5t/minitest-matchers_vaccine/actions?query=workflow%3ACI)
[![Maintainability](https://api.codeclimate.com/v1/badges/ca7aadb1a0a1c1c6782e/maintainability)](https://codeclimate.com/github/rmm5t/minitest-matchers_vaccine)

Adds matcher support to minitest without all the other RSpec-style expectation
_infections_.

Using matchers with RSpec-style expectations requires that we _infect_ the
objects that we are testing with new methods. Matcher implementations are
typically overkill, but there are a lot of good testing libraries that still
insist on standardizing on matchers. These matchers still have some value, and
this gem tries to extract that value with straight-forward assertions that
adhere to the matcher spec.

**Why not use
[minitest-matchers](https://github.com/wojtekmach/minitest-matchers)?** This
gem is actually heavily inspired by and based upon the assertions in
minitest-matchers; however, everything else that minitest-matchers brings to
the table is unnecessary unless you're bent on a true RSpec-style syntax.

## Installation

Add this line to your application's Gemfile:

    gem "minitest-matchers_vaccine"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-matchers_vaccine

## Usage

Includes both `assert_must` and `assert_wont` assertions, but also includes
`must` and `wont` facilitator assertions that automatically default to using
the current `subject` method (aka "let variable") or `@subject` instance
variable.

**NOTE:** This gem does not allow matchers to be used with an expectation
  syntax. Let's avoid infecting the objects we're testing.

### Minitest::Test

```ruby
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

  # Works with matchers in other libs
  def test_stripping
    assert_must strip_attribute(:name), User.new
  end
end
```

### Minitest::Spec

```ruby
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

  # Works with matchers in other libs
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
