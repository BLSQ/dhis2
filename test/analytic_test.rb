require "test_helper"
require "awesome_print"

class AnalyticTest < Minitest::Test
  def test_list
    de                = Dhis2.client.data_elements.find_by(name: "Expected pregnancies")
    organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma Station CHP")
    period            = "2015"

    value = Dhis2.client.data_values.find(
      period:            period,
      data_element:      de.id,
      organisation_unit: organisation_unit.id
    )

    row = Dhis2.client.analytics.list(
      data_elements: de.id,
      organisation_units: organisation_unit.id,
      periods: period
    )["rows"].first

    assert_equal de.id, row[0]
    assert_equal organisation_unit.id, row[1]
    assert_equal period, row[2]
    assert_equal value.to_i, row[3].to_i

  end
end
