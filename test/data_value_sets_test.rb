require "test_helper"

class DataValueSetsTest < Minitest::Test
  def test_list_values_multiple_units
    ds = Dhis2::DataSet.find_by(name: "Child Health")
    parent_organisation_unit = Dhis2::OrganisationUnit.find_by(name: "Baoma")
  
    units = parent_organisation_unit.children[0..4].map { |ou| ou["id"] }

    period = "201512"

    value_sets = Dhis2::DataValueSets.list(
      data_sets:         [ds.id],
      organisation_unit: units,
      periods:           [period]
    )

    assert_equal 137, value_sets.values.size
    assert_equal units.sort, value_sets.values.map { |v| v["orgUnit"] }.uniq.sort
  end
  
  def test_list_values
    ds = Dhis2::DataSet.find_by(name: "Child Health")
    organisation_unit = Dhis2::OrganisationUnit.find_by(name: "Baoma")
    period = "201512"

    value_sets = Dhis2::DataValueSets.list(
      data_sets:         [ds.id],
      organisation_unit: organisation_unit.id,
      periods:           [period]
    )
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

  def test_create_values
    org_units = Dhis2::OrganisationUnit.list(page_size: 2)
    data_elements = Dhis2::DataElement.list(page_size: 2)

    tuple = [{
      dataElement: data_elements.first.id,
      orgUnit: org_units.first.id,
      period: "201601", value: 36
    }]
    status = Dhis2::DataValueSets.create(tuple)
    assert_equal true, status.success?
  end
end
