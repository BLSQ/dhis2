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
        periods = options[:periods]

        organisation_unit_id = options[:organisation_unit]
        children = options[:children] || true
        
        if organisation_unit_id.class == Array
          ou_url = organisation_unit_id.map { |ou_id| "orgUnit=#{ou_id}" }.join("&") + "&children=#{children}"
        else
          ou_url = "orgUnit=#{organisation_unit_id}&children=#{children}"
        end

        data_sets_url = data_set_ids.map { |ds| "dataSet=#{ds}" }.join("&")
        periods = periods.map { |period| "period=#{period}" }.join("&")

        params = [data_sets_url, periods, ou_url].join("&")
        new(Dhis2.client.get("dataValueSets?" + params))
      end
    end
  end
end
