# frozen_string_literal: true
require "test_helper"

class AnalyticTest < Minitest::Test
  def test_list
    row = Dhis2.client.analytics.list(
      data_elements:      de.id,
      organisation_units: organisation_unit.id,
      periods:            period
    )["rows"].first

    assert_equal de.id, row[0]
    assert_equal organisation_unit.id, row[1]
    assert_equal period, row[2]
    assert_equal value.to_i, row[3].to_i
  end

  def test_list_with_filter
    row = Dhis2.client.analytics.list(
      data_elements:      de.id,
      organisation_units: organisation_unit.id,
      periods:            period,
      filter:             "#{organisation_unit_group.organisation_unit_group_set['id']}:#{organisation_unit_group.id}"
    )["rows"].first

    assert_equal de.id, row[0]
    assert_equal organisation_unit.id, row[1]
    assert_equal period, row[2]
    refute_equal value.to_i, row[3].to_i
  end

  def de
    @de ||= Dhis2.client.data_elements.find_by(name: "Expected pregnancies")
  end

  def de_group
    id = de.data_element_groups[0]["id"]
    Dhis2.client.data_element_groups.find(id)
  end

  def organisation_unit
    @organisation_unit ||= Dhis2.client.organisation_units.find_by(name: "Baoma")
  end

  def organisation_unit_group
    @organisation_unit_group ||= Dhis2.client.organisation_unit_groups.find_by(name: "CHP")
  end

  def period
    @period ||= "2016"
  end

  def values_set
    @values_set ||= Dhis2.client.data_value_sets.list(
      data_element_groups: [de_group.id],
      organisation_unit:   [organisation_unit.id],
      periods:             [period]
    )
  rescue => e
    p e.response.request
    p e.response.body
  end

  def value
    sorted_data_values = values_set.data_values.select do |dataValue|
      dataValue["data_element"] == de.id
    end
    sorted_data_values.map { |dataValue| dataValue["value"].to_i }.reduce(:+)
  end
end
