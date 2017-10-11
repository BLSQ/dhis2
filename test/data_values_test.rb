# frozen_string_literal: true
require "test_helper"

class DataValuesTest < Minitest::Test
  def test_get_values
    de                = Dhis2.client.data_elements.find_by(name: "Expected pregnancies")
    organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma Station CHP")
    period            = "2015"

    value = Dhis2.client.data_values.find(
      period:            period,
      data_element:      de.id,
      organisation_unit: organisation_unit.id
    )

    assert_equal "159", value
  end
end
