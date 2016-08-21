require "base"

module Dhis2
  class OrganisationUnit < Base
    attr_reader :id, :display_name, :level, :parent_id, :children_ids

    def initialize(params)
      super(params)
      @level = params["level"]
      @parent_id = params["parent"]["id"] if params["parent"]
      @children_ids = params["children"] ? params["children"].map { |raw| raw["id"] } : []
    end
  end
end
