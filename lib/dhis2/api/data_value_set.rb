# frozen_string_literal: true
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
          response = client.post(resource_name, body)
          Dhis2::Status.new(response)
        end

        def list(client, options)
          new(client, client.get(build_list_url(client, options)))
        end

        def build_list_url(_client, options)
          params = [build_what_url(options),  build_when_url(options), build_where_url(options)].join("&")
          resource_name + "?" + params
        end

        def build_what_url(options)
          data_set_ids  = options[:data_sets]
          if data_set_ids
            data_sets_url = data_set_ids.map { |ds| "dataSet=#{ds}" }.join("&")
          else
            data_element_groups = options[:data_element_groups]
            data_sets_url = data_element_groups.map { |deg| "dataElementGroup=#{deg}" }.join("&") if data_element_groups
          end
        end

        def build_when_url(options)
          periods = options[:periods]
          if periods
            periods = periods.map { |period| "period=#{period}" }.join("&")
          else
            start_date = options[:start_date]
            end_date = options[:end_date]
            date_args = []
            date_args.push "startDate=#{start_date}" if start_date
            date_args.push "endDate=#{end_date}" if end_date
            periods = date_args.join("&")
          end
          periods
        end

        def build_where_url(options)
          children  = options[:children] || true
          organisation_unit_id = options[:organisation_unit]
          organisation_unit_group = options[:organisation_unit_group]
          if organisation_unit_id
            if organisation_unit_id.class == Array
              ou_url = organisation_unit_id.map { |ou_id| "orgUnit=#{ou_id}" }.join("&") + "&children=#{children}"
            else
              ou_url = "orgUnit=#{organisation_unit_id}&children=#{children}"
            end
          else
            ou_url = "orgUnitGroup=#{organisation_unit_group}"
          end
          ou_url
        end
      end
    end
  end
end
