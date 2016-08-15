require 'test_helper'

class Dhis2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dhis2::VERSION
  end

  def test_get_org_units
    connect
    org_units = Dhis2.org_units(fields: %w(parent children level id displayName))

    assert_equal 50, org_units.size
  end

  def test_get_org_unit_levels
    connect
    org_unit_levels = Dhis2.org_unit_levels

    assert_equal 4, org_unit_levels.size

    org_unit_levels.each do |org_unit_level|
      refute_nil org_unit_level.name
      refute_nil org_unit_level.id
      refute_nil org_unit_level.level
    end
  end

  def test_get_org_units_by_level
    connect
    org_units = Dhis2.org_units(filter: "level:eq:2", fields: %w(id level displayName parent))

    assert_equal 13, org_units.size

    org_units.each do |org_unit|
      assert_equal 2, org_unit.level
    end
  end

  def connect
    Dhis2.connect(url: "https://play.dhis2.org/demo", user: "admin", password: "district")
  end
end
