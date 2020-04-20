# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dhis2/version"

Gem::Specification.new do |spec|
  spec.name          = "dhis2"
  spec.version       = Dhis2::VERSION
  spec.authors       = ["Martin Van Aken"]
  spec.email         = ["mvanaken@bluesquare.org"]

  spec.summary       = "Simple Ruby wrapper on DHIS2 API."
  spec.description   = 'Allows to retreive items from a DHIS2 server in a more "Ruby way".'
  spec.homepage      = "http://github.com/blsq/dhis2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "dry-validation", "0.11.1"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "faker", "~> 1.6", ">= 1.6.3"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock", "3.1.0"
  spec.add_development_dependency "simplecov", "< 0.18.0"
  spec.add_development_dependency "rest-client-logger"
end
