# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      class Analytic
        def self.list(client, periods: nil, organisation_units: nil, data_elements: nil, filter: nil, raw: false, skipMeta: false)
          params = []
          params << [:skipMeta, "true"] if skipMeta
          params << [:dimension, "pe:#{periods}"] if periods
          params << [:dimension, "ou:#{organisation_units}"] if organisation_units
          params << [:dimension, "dx:#{data_elements}"] if data_elements
          params << [:filter, filter.to_s] if filter

          client.get(path: "analytics", query_params: RestClient::ParamsArray.new(params), raw: raw)
        end
      end
    end
  end
end
