module Dhis2
  module Api
    class Analytic < Base
      class << self
        def list(client, periods:, organisation_unit:, data_elements:)
          params = RestClient::ParamsArray.new([
            [:dimension, "ou:#{organisation_unit}"],
            [:dimension, "dx:#{data_elements}"],
            [:dimension, "pe:#{periods}"]
          ])
          client.get(self.resource_name, params)
        end
      end
    end
  end
end
