require 'test_helper'

class Dhis2Test < Minitest::Test
  def setup
    Dhis2.connect(url: "https://play.dhis2.org/demo", user: "admin", password: "district")
  end

  def test_that_it_has_a_version_number
    refute_nil ::Dhis2::VERSION
  end

  def test_get_org_units
    org_units = Dhis2.org_units(fields: %w(parent children level id displayName))
    assert_equal 50, org_units.size
  end

  def test_get_org_units_all_fields
    org_units = Dhis2.org_units(fields: [":all"], page_size: 1)
    assert_equal 1, org_units.size
    org_unit = org_units.first

    refute_nil org_unit.level
    refute_nil org_unit.shortName
    refute_nil org_unit.shortName
    refute_nil org_unit.lastUpdated
  end

  def test_get_data_elements
    data_elements = Dhis2.data_elements(fields: %w(id displayName code), page_size: 1)
    assert_equal 1, data_elements.size

    data_element = data_elements.first

    refute_nil data_element.display_name
    refute_nil data_element.id
    refute_nil data_element.code
  end

  def test_create_data_elements
    elements = [
      { name: "TesTesT1", short_name: "TTT1" },
      { name: "TesTesT2", short_name: "TTT2" }
    ]
    status = Dhis2.create_data_elements(elements)
    assert_equal true, status.success?
    assert_equal 2, status.total_imported
  end

  def test_get_data_element
    data_elements = Dhis2.data_elements(fields: %w(id displayName code), page_size: 1 )
    assert_equal 1, data_elements.size

    data_element = Dhis2.data_element(data_elements.first.id)

    refute_nil data_element.display_name
    refute_nil data_element.id
    refute_nil data_element.code
  end

  def test_get_org_units_pagination
    org_units = Dhis2.org_units(fields: %w(parent children level id displayName), page: 6)
    assert_equal 50, org_units.size
    refute_nil org_units.pager
    assert_equal 6, org_units.pager.page
  end

  def test_get_org_units_fields
    org_units = Dhis2.org_units(fields: %w(parent children level id code displayName), page_size: 1)

    assert_equal 1, org_units.size
    refute_nil org_units.first.code
  end

  def test_get_org_unit_levels
    org_unit_levels = Dhis2.org_unit_levels

    assert_equal 4, org_unit_levels.size

    org_unit_levels.each do |org_unit_level|
      refute_nil org_unit_level.name
      refute_nil org_unit_level.id
      refute_nil org_unit_level.level
    end
  end

  def test_get_org_units_by_level
    org_units = Dhis2.org_units(filter: "level:eq:2", fields: %w(id level displayName parent))

    assert_equal 13, org_units.size

    org_units.each do |org_unit|
      assert_equal 2, org_unit.level
    end
  end

end
