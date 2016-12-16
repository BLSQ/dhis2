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

  def test_create_org_unit_groups
    org_unit_group_name_1 = SecureRandom.uuid
    org_unit_groups = {name: org_unit_group_name_1, short_name: org_unit_group_name_1, code:"test", id:"Ysjldlkdsflksfs"}
    status = Dhis2.client.organisation_unit_groups.create(org_unit_groups)
    assert_equal false, status.success?
    assert_equal 1, status.total_imported
    org_unit_group_1 = Dhis2.client.organisation_unit_groups.list(fields: :all, filter: "name:eq:#{org_unit_group_name_1}").first
    assert_equal org_unit_group_name_1, org_unit_group_1.short_name
    assert_equal "Ysjldlkdsflksfs", org_unit_group_1.uid
  end
end
