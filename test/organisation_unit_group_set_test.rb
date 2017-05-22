# frozen_string_literal: true

require "test_helper"

class OrganisationUnitGroupSetsTest < Minitest::Test
  def test_group_sets
    group_sets = Dhis2.client.organisation_unit_group_sets.list(
      fields:    %w[id displayName code],
      page_size: 10_000
    )
    assert_equal true, group_sets.map(&:display_name).include?("Facility Type")
  end
end
