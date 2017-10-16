# frozen_string_literal: true

module Dhis2
  module Api
    class OrganisationUnitGroupSet < Base
      class << self
        def create(client, orgunit_group_sets)
          response = client.post(
            "metadata",
            organisation_unit_group_sets: ensure_array(orgunit_group_sets)
          )
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
