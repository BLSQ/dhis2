module Dhis2
  class OrganisationUnitGroup < Base
    def initialize(params)
      super(params)
    end

    def organisation_unit_ids
      organisationUnits.map { |ou| ou["id"] }
    end
  end
end
