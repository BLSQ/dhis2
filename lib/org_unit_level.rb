module Dhis2
  class OrgUnitLevel
    attr_reader :id, :name, :level

    def initialize(params)
      @id = params["id"]
      @name = params["name"]
      @level = params["level"]
    end
  end
end
