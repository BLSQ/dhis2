# frozen_string_literal: true
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

  def test_should_build_list_url_for_oug_deg_start_end
    url = Dhis2.client.data_value_sets.build_list_url(
      organisation_unit_group: "oRVt7g429ZO",
      data_element_groups:     ["oDkJh5Ddh7d"],
      start_date:              Date.parse("31-1-2015"),
      end_date:                Date.parse("28-02-2015")
    )

    assert_equal url, "dataValueSets?dataElementGroup=oDkJh5Ddh7d&startDate=2015-01-31&endDate=2015-02-28&orgUnitGroup=oRVt7g429ZO"
  end

  def test_should_build_list_url_for_ds_periods_ou
    url = Dhis2.client.data_value_sets.build_list_url(
      data_sets:         ["oRVt7g429ZO"],
      periods:           ["oDkJh5Ddh7d"],
      organisation_unit: "123456"
    )

    assert_equal url, "dataValueSets?dataSet=oRVt7g429ZO&period=oDkJh5Ddh7d&orgUnit=123456&children=true"
  end

  def test_should_build_list_url_for_ds_periods_ou
    url = Dhis2.client.data_value_sets.build_list_url(
      data_sets:         ["oRVt7g429ZO"],
      periods:           ["oDkJh5Ddh7d"],
      organisation_unit: "123456"
    )

    assert_equal url, "dataValueSets?dataSet=oRVt7g429ZO&period=oDkJh5Ddh7d&orgUnit=123456&children=true"
  end

  def test_should_build_list_url_for_ds_periods_multiple_ou
    url = Dhis2.client.data_value_sets.build_list_url(
      data_sets:         ["oRVt7g429ZO"],
      periods:           ["oDkJh5Ddh7d"],
      organisation_unit: ["123456","789456"]
    )

    assert_equal url, "dataValueSets?dataSet=oRVt7g429ZO&period=oDkJh5Ddh7d&orgUnit=123456&orgUnit=789456&children=true"
  end

  def test_list_values_orgunitsgroup_startdate_enddate_dataelement_group
    # https://play.dhis2.org/demo/api/dataValueSets?dataElementGroup=oDkJh5Ddh7d&startDate=2015-01-31&endDate=2015-02-28&orgUnitGroup=oRVt7g429ZO

    value_sets = Dhis2.client.data_value_sets.list(
      organisation_unit_group: "oRVt7g429ZO",
      data_element_groups:     ["oDkJh5Ddh7d"],
      start_date:              Date.parse("31-1-2015"),
      end_date:                Date.parse("28-02-2015")
    )
    assert_equal 1816, value_sets.values.size
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
