module Dhis2
  class OrganisationUnitLevel < Base
    def initialize(params)
      super(params)
    end

    class << self
      def default_fields
        %w(id name level)
      end
    end
  end
end
