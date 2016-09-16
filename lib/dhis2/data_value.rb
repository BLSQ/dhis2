module Dhis2
  class DataValue
    class << self
      def get(period:, organisation_unit:, data_element:)
        params = {pe: period, ou: organisation_unit, de: data_element}

        Dhis2.client.get("dataValues", params).first
      end
    end
  end
end
