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

    class << self
      def find(id)
        response = Dhis2.get_resource("organisationUnits/#{id}").get
        json_response = JSON.parse(response)
        self.new(json_response)
      end

      def list(options = {})
        response = Dhis2.get_resource("organisationUnits", options).get
        json_response = JSON.parse(response)
        PaginatedArray.new(json_response["organisationUnits"].map { |raw_org_unit| self.new(raw_org_unit) }, json_response["pager"])
      end
    end
  end
end
