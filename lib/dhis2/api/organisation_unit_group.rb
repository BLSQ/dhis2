# frozen_string_literal: true

module Dhis2
  module Api
    class OrganisationUnitGroup < Base
      def organisation_unit_ids
        organisation_units.map do |organisation_unit|
          organisation_unit["id"]
        end
      end

      def group_set_ids
        [organisation_unit_group_set, group_sets].flatten.compact.map do |group_set|
          group_set["id"]
        end
      end

      class << self
        def create(client, orgunit_groups)
          ou_groups = {
            organisation_unit_groups: ensure_array(orgunit_groups).map do |orgunit_group|
              {
                name:       orgunit_group[:name],
                short_name: orgunit_group[:short_name],
                code:       orgunit_group[:code] || orgunit_group[:short_name]
              }.tap do |mapped_orgunit_group|
                mapped_orgunit_group[:id] = orgunit_group[:id] if orgunit_group[:id]
              end
            end
          }
          Dhis2::Status.new(client.post("metadata", ou_groups))
        end
      end
    end
  end
end
