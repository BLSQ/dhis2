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
    refute_nil org_unit.lastUpdated
  end

  def test_find_org_units
    org_units_by_list = Dhis2::OrganisationUnit.list(fields: %w(id), page_size: 9)
    ids = org_units_by_list.map(&:id)

    org_units = Dhis2::OrganisationUnit.find(ids)

    assert_equal org_units_by_list.size, org_units.size

    org_units_by_list.each do |ou|
      assert org_units.include?(ou)
    end
  end

  def test_org_units_children
     org_unit_id = Dhis2::OrganisationUnit.find_by(name: "Bo").id

     org_units_with_children = Dhis2::OrganisationUnit.find(org_unit_id, includeChildren: true)
     assert_equal 16, org_units_with_children.size
  end

  def test_org_units_descendants
     org_unit_id = Dhis2::OrganisationUnit.find_by(name: "Bo").id

     org_units_with_children = Dhis2::OrganisationUnit.find(org_unit_id, includeDescendants: true)

     assert_equal 141, org_units_with_children.size

     assert_equal 125, org_units_with_children.select { |ou| ou.level == 4 }.size
  end

  def test_list_org_units_all_fields
    org_units = Dhis2::OrganisationUnit.list(fields: :all, page_size: 1)
    assert_equal 1, org_units.size
    org_unit = org_units.first

    refute_nil org_unit.level
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
