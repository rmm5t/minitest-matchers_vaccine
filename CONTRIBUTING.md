## Want to Contribute?

Awesome. We love help, but before getting started, please read:

**[Don't "Push" Your Pull Requests](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)**

## Ready for a Pull-Request?

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rake`

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

## Testing Against Minitest 5 and 6

Run these commands from the repository root to test against each supported
Minitest major version. Use Ruby 3.2 or newer to run both versions.

```sh
BUNDLE_GEMFILE=gemfiles/minitest-5.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/minitest-5.gemfile bundle exec rake

BUNDLE_GEMFILE=gemfiles/minitest-6.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/minitest-6.gemfile bundle exec rake
```

Also test the minimum supported Minitest version with the pinned Gemfile:

```sh
BUNDLE_GEMFILE=gemfiles/minitest-5-minimum.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/minitest-5-minimum.gemfile bundle exec rake
```

CI runs this lower-bound check on Ruby 2.4 and 4.0. See the
[compatibility policy](README.md#compatibility) for the supported combinations.

## Testing With Real Matchers

The integration suite uses `rspec-expectations` matchers to check positive and
negative assertions, matcher-specific negation, and failure messages. Run it
with the dedicated Gemfiles:

```sh
BUNDLE_GEMFILE=gemfiles/minitest-5-integration.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/minitest-5-integration.gemfile bundle exec rake test:integration

BUNDLE_GEMFILE=gemfiles/minitest-6-integration.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/minitest-6-integration.gemfile bundle exec rake test:integration
```

CI runs these checks on Ruby 3.2 and 4.0 with both Minitest majors. The default
`bundle exec rake` task runs the unit suite; use `test:integration` to run the
real-matcher checks with their additional dependencies.

## Conventions

* Use idiomatic Ruby and Minitest assertions and helpers.
* Include tests that fail without your code, and pass with your code.
* Update the documentation, the surrounding one, examples elsewhere, guides,
  whatever is affected by your contribution

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer `&&`/`||` over `and`/`or`.
* `MyClass.my_method(my_arg)` not `my_method( my_arg )` or `my_method my_arg`.
* `a = b` not `a=b`.
* Follow the conventions you see used in the source already.
