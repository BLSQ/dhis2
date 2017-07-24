# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhis2/version'

Gem::Specification.new do |spec|
  spec.name          = "dhis2"
  spec.version       = Dhis2::VERSION
  spec.authors       = ["Martin Van Aken"]
  spec.email         = ["mvanaken@bluesquare.org"]

  spec.summary       = %q{Simple Ruby wrapper on DHIS2 API.}
  spec.description   = %q{Allows to retreive items from a DHIS2 server in a more "Ruby way".}
  spec.homepage      = "http://github.com/blsq/dhis2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "faker", "~> 1.6", ">= 1.6.3"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rest-client-logger"

end
