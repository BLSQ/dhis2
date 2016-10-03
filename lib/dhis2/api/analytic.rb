module Dhis2
  module Api
    class Analytic < Base
      class << self
        def find(client, periods:, organisation_unit:, data_elements:)
          params = "dimension=dx:#{data_elements}&dimension=ou:#{organisation_unit}&dimension=pe:#{periods}";
          client.get_with_string_params(self.resource_name, params)
        end
      end
    end
  end
end
