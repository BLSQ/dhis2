require 'test_helper'

class Dhis2Test < Minitest::Test
  def test_configure
    Dhis2.configure do |config|
      config.url      = "https://play.dhis2.org/demo"
      config.user     = "admin"
      config.password = "district"
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Dhis2::VERSION
  end
end
