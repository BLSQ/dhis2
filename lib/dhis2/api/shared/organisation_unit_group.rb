# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module OrganisationUnitGroup
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
      end
    end
  end
end
