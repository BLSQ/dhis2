module Dhis2
  module Api
    class OrganisationUnitGroup < Base
      def organisation_unit_ids
        organisation_units.map do |organisation_unit|
          organisation_unit["id"]
        end
      end
    end
  end
end
