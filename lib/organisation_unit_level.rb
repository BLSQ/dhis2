require "base"

module Dhis2
  class OrganisationUnitLevel < Base
    attr_reader :id, :name, :level

    def initialize(params)
      super(params)
      @name = params["name"]
      @level = params["level"]
    end

    class << self
      def default_fields
        %w(id name level)
      end
    end
  end
end
