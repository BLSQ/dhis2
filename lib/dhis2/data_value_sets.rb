module Dhis2
  class DataValueSets < Base
    def values
      dataValues.map { |dv| OpenStruct.new(dv) }
    end

    class << self
      def create(tuples)
        body = { dataValues: tuples }
        response = Dhis2.client.post("dataValueSets", body)
        Dhis2::Status.new(response)
      end

      def list(options)
        data_set_ids = options[:data_sets]
        organisation_unit_id = options[:organisation_unit]
        periods = options[:periods]
        children = options[:children] || true
        data_sets_url = data_set_ids.map { |ds| "dataSet=#{ds}" }.join("&")
        ou_url = "orgUnit=#{organisation_unit_id}&children=#{children}"
        periods = periods.map { |period| "period=#{period}" }.join("&")

        params = [data_sets_url, periods, ou_url].join("&")
        new(Dhis2.client.get("dataValueSets?" + params))
      end
    end
  end
end
