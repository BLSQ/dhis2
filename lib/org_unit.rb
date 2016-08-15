require "base"

module Dhis2
  class OrgUnit < Base
    attr_reader :id, :display_name, :level, :parent_id, :children_ids

    def initialize(params)
      super(params)
      @id = params["id"]
      @display_name = params["displayName"]
      @level = params["level"]
      @parent_id = params["parent"]["id"] if params["parent"]
      @children_ids = params["children"] ? params["children"].map { |raw| raw["id"] } : []
    end
  end
end
