require "test_helper"

class OrganisationUnitTest < Minitest::Test
  def test_list_org_units
    org_units = Dhis2::OrganisationUnit.list(fields: %w(parent children level id displayName))
    assert_equal 50, org_units.size
  end

  def test_find_org_unit
    org_units = Dhis2::OrganisationUnit.list(fields: %w(id), page_size: 1)
    id = org_units.first.id
    org_unit = Dhis2::OrganisationUnit.find(id)

    assert_equal id, org_unit.id
    refute_nil org_unit.level
    refute_nil org_unit.shortName
    refute_nil org_unit.shortName
    refute_nil org_unit.lastUpdated
  end

  def test_list_org_units_all_fields
    org_units = Dhis2::OrganisationUnit.list(fields: :all, page_size: 1)
    assert_equal 1, org_units.size
    org_unit = org_units.first

    refute_nil org_unit.level
    refute_nil org_unit.shortName
    refute_nil org_unit.shortName
    refute_nil org_unit.lastUpdated
  end

  def test_list_org_units_pagination
    org_units = Dhis2::OrganisationUnit.list(fields: %w(parent children level id displayName), page: 6)
    assert_equal 50, org_units.size
    refute_nil org_units.pager
    assert_equal 6, org_units.pager.page
  end

  def test_list_org_units_fields
    org_units = Dhis2::OrganisationUnit.list(fields: %w(parent children level id code displayName), page_size: 1)

    assert_equal 1, org_units.size
    refute_nil org_units.first.code
  end

  def test_list_org_units_by_level
    org_units = Dhis2::OrganisationUnit.list(filter: "level:eq:2", fields: %w(id level displayName parent))

    assert_equal 13, org_units.size

    org_units.each do |org_unit|
      assert_equal 2, org_unit.level
    end
  end
end