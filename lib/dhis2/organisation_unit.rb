module Dhis2
  class OrganisationUnit < Base
    def initialize(params)
      super(params)
      self.parent_id    = params["parent"]["id"] if params["parent"]
      self.children_ids = params["children"] ? params["children"].map { |raw| raw["id"] } : []
    end

    class << self
      def last_level_descendants(id)
        levels = OrganisationUnitLevel.list(fields: :all)
        last_level = levels.map(&:level).sort.last

        OrganisationUnit.find(id, includeDescendants: true).select { |ou| ou.level == last_level }
      end
    end
  end
end
