module Dhis2
  module Api
    class OrganisationUnitGroupSet < Base
      class << self
        def create(client, orgunit_group_sets)
          orgunit_group_sets = [orgunit_group_sets].flatten
          response = client.post("metadata",
                                 organisation_unit_group_sets: orgunit_group_sets)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
