require "securerandom"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "dhis2"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "byebug"

Dhis2.configure do |config|
  config.url      = "https://play.dhis2.org/demo"
  config.user     = "admin"
  config.password = "district"
end
