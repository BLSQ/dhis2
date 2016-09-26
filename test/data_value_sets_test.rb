require "test_helper"

class DataValueSetsTest < Minitest::Test
  def test_list_values_multiple_units
    ds = Dhis2.client.data_sets.find_by(name: "Child Health")
    parent_organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma")

    units = parent_organisation_unit.children[0..4].map { |ou| ou["id"] }

    period = "201512"

    value_sets = Dhis2.client.data_value_sets.list(
      data_sets:         [ds.id],
      organisation_unit: units,
      periods:           [period]
    )

    assert_equal 137, value_sets.values.size
    assert_equal units.sort, value_sets.values.map { |v| v["org_unit"] }.uniq.sort
  end

  def test_list_values
    ds = Dhis2.client.data_sets.find_by(name: "Child Health")
    organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma")
    period = "201512"

    value_sets = Dhis2.client.data_value_sets.list(
      data_sets:         [ds.id],
      periods:           [period],
      organisation_unit: organisation_unit.id
    )
    assert_equal ds.id, value_sets.data_set
    assert_equal period, value_sets.period
    assert_equal organisation_unit.id, value_sets.org_unit

    assert_equal 466, value_sets.values.size

    value = value_sets.values.first

    refute_nil value.value
    refute_nil value.data_element
    refute_nil value.period
    refute_nil value.org_unit
  end

  def test_create_values
    org_units     = Dhis2.client.organisation_units.list(page_size: 2)
    data_elements = Dhis2.client.data_elements.list(page_size: 2)
    tuple         = [{
      value:        36,
      period:       "201601",
      org_unit:     org_units.first.id,
      data_element: data_elements.first.id
    }]
    status = Dhis2.client.data_value_sets.create(tuple)
    assert_equal true, status.success?
  end
end
