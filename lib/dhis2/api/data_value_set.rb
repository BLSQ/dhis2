module Dhis2
  module Api
    class DataValueSet < Base
      def values
        data_values.map do |data_value|
          OpenStruct.new(data_value)
        end
      end

      class << self
        def create(client, tuples)
          body = { dataValues: tuples }
          response = client.post(self.resource_name, body)
          Dhis2::Status.new(response)
        end

        def list(client, options)
          data_set_ids         = options[:data_sets]
          periods              = options[:periods]

          organisation_unit_id = options[:organisation_unit]
          children             = options[:children] || true

          if organisation_unit_id.class == Array
            ou_url = organisation_unit_id.map { |ou_id| "orgUnit=#{ou_id}" }.join("&") + "&children=#{children}"
          else
            ou_url = "orgUnit=#{organisation_unit_id}&children=#{children}"
          end

          data_sets_url = data_set_ids.map { |ds| "dataSet=#{ds}" }.join("&")
          periods       = periods.map { |period| "period=#{period}" }.join("&")

          params = [data_sets_url, periods, ou_url].join("&")
          new(client, client.get(self.resource_name + "?" + params))
        end
      end
    end
  end
end
