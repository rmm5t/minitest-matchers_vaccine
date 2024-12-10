# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/matchers_vaccine/version'

Gem::Specification.new do |spec|
  username           = "rmm5t"
  spec.name          = "minitest-matchers_vaccine"
  spec.version       = Minitest::MatchersVaccine::VERSION
  spec.authors       = ["Ryan McGeary"]
  spec.email         = ["ryan@mcgeary.org"]
  spec.summary       = %q{Adds support for RSpec-style matchers to minitest.}
  spec.description   = %q{Adds matcher support to minitest without all the other RSpec-style expectation "infections."}
  spec.homepage      = "https://github.com/#{username}/#{spec.name}"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,test}/**/*", "README*", "LICENSE*"]
  spec.test_files    = Dir["{test}/**/*"]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri"   => "#{spec.homepage}/issues",
    "changelog_uri"     => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "source_code_uri"   => spec.homepage,
    "funding_uri"       => "https://github.com/sponsors/#{username}",
  }

  spec.required_ruby_version = ">= 1.9"

  spec.add_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake"
end
