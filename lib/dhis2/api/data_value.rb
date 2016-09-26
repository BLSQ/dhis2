module Dhis2
  module Api
    class DataValue < Base
      class << self
        def find(client, period:, organisation_unit:, data_element:)
          params = { pe: period, ou: organisation_unit, de: data_element }

          client.get(self.resource_name, params).first
        end
      end
    end
  end
end
