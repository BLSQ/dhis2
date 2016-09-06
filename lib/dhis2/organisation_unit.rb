module Dhis2
  class OrganisationUnit < Base
    def initialize(params)
      super(params)
      self.parent_id    = params["parent"]["id"] if params["parent"]
      self.children_ids = params["children"] ? params["children"].map { |raw| raw["id"] } : []
    end
  end
end
