require "test_helper"

class OrganisationUnitGroupTest < Minitest::Test
  def test_list_organisation_unit_groups
    organisation_unit_groups = Dhis2.client.organisation_unit_groups.list(fields: :all, page_size: 1)
    assert_equal 1, organisation_unit_groups.size

    organisation_unit_group = organisation_unit_groups.first

    assert_equal 194, organisation_unit_group.organisation_units.size
    assert_equal 194, organisation_unit_group.organisation_unit_ids.size

    refute_nil organisation_unit_group.id
    assert_equal "CHC", organisation_unit_group.display_name
  end

  def test_find_by_name
    organisation_unit_group = Dhis2.client.organisation_unit_groups.find_by(name: "CHC")
    assert_equal "CHC", organisation_unit_group.display_name
  end
end
