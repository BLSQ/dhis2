require "test_helper"

class DataValuesTest < Minitest::Test
  def test_get_values
    de = Dhis2::DataElement.find_by(name: "Expected pregnancies")
    organisation_unit = Dhis2::OrganisationUnit.find_by(name: "Baoma Station CHP")
    period = "2015"

    value = Dhis2::DataValue.get(
      data_element:         de.id,
      organisation_unit: organisation_unit.id,
      period:           period
    )

    assert_equal "159", value
  end
end
