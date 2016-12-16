module Dhis2
  module Api
    class OrganisationUnitGroup < Base
      def organisation_unit_ids
        organisation_units.map do |organisation_unit|
          organisation_unit["id"]
        end
      end

      class << self
        def create(client, orgunit_groups)
          orgunit_groups = [orgunit_groups].flatten
          ou_groups = {
            organisation_unit_groups: orgunit_groups.map do |orgunit_group|
              mapped_orgunit_group = {
                name:       orgunit_group[:name],
                short_name: orgunit_group[:short_name],
                code:       orgunit_group[:code] || orgunit_group[:short_name]
              }
              mapped_orgunit_group[:id] = orgunit_group[:id] if orgunit_group[:id]
              mapped_orgunit_group
            end
          }
          response = client.post("metadata", ou_groups)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
