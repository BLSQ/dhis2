module Dhis2
  module Api
    class Analytic < Base
      class << self
        def list(client, periods:, organisation_units:, data_elements:, filter: nil, dimension: nil)
          params = [
            [:dimension, "ou:#{organisation_units}"],
            [:dimension, "dx:#{data_elements}"],
            [:dimension, "pe:#{periods}"]
          ]
          params << [:filter, "#{filter}"] if filter
          params << [:dimension, "#{dimension}"] if dimension
          client.get(self.resource_name, RestClient::ParamsArray.new(params))
        end
      end
    end
  end
end
