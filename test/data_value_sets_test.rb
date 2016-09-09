require "test_helper"

class DataValueSetsTest < Minitest::Test
  def test_list_values
    ds = Dhis2::DataSet.find_by(name: "Child Health")
    organisation_unit = Dhis2::OrganisationUnit.find_by(name: "Baoma")
    period = "201512"

    value_sets = Dhis2::DataValueSets.list(data_sets: [ds.id], organisation_unit: organisation_unit.id, periods: [period])
    assert_equal ds.id, value_sets.dataSet
    assert_equal period, value_sets.period
    assert_equal organisation_unit.id, value_sets.orgUnit

    assert_equal 466, value_sets.values.size

    value = value_sets.values.first

    refute_nil value.value
    refute_nil value.dataElement
    refute_nil value.period
    refute_nil value.orgUnit
  end
end
