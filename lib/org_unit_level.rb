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
  end
end
