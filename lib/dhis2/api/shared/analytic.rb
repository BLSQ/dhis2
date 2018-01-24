# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      class Analytic
        def self.list(client, periods:, organisation_units:, data_elements: nil, filter: nil)
          params = [
            [:dimension, "ou:#{organisation_units}"],
            [:dimension, "pe:#{periods}"]
          ]
          params << [:dimension, "dx:#{data_elements}"] if data_elements
          params << [:filter, filter.to_s] if filter

          client.get(path: "analytics", query_params: RestClient::ParamsArray.new(params))
        end
      end
    end
  end
end
