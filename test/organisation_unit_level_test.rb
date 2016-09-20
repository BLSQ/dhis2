require "test_helper"

class OrganisationUnitLevelTest < Minitest::Test
  def test_get_org_unit_levels
    org_unit_levels = Dhis2.client.organisation_unit_levels.list(fields: :all)

    assert_equal 4, org_unit_levels.size

    org_unit_levels.each do |org_unit_level|
      refute_nil org_unit_level.name
      refute_nil org_unit_level.id
      refute_nil org_unit_level.level
    end
  end
end
