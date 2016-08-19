require "base"

module Dhis2
  class OrgUnitLevel < Base
    attr_reader :id, :name, :level

    def initialize(params)
      super(params)
      @id = params["id"]
      @name = params["name"]
      @level = params["level"]
    end

    class << self
      def list(options = {})
        response = Dhis2.get_resource("organisationUnitLevels", fields: %w(id name level)).get
        json_response = JSON.parse(response)
        PaginatedArray.new(
          json_response["organisationUnitLevels"].map { |raw_org_unit_level| self.new(raw_org_unit_level) }, 
          json_response["pager"]
        )
      end
    end
  end
end
