require 'test_helper'

class Dhis2Test < Minitest::Test
  def test_connect
    # Dhis2.connect(url: "https://play.dhis2.org/demo", user: "admin", password: "district")
    Dhis2.connect(url: "http://127.0.1.1:8082", user: "admin", password: "district")
  end

  # def test_cannot_connect_without_url
  #   Dhis2.connect(user: "admin", password: "district")
  # end

  def test_that_it_has_a_version_number
    refute_nil ::Dhis2::VERSION
  end
end
