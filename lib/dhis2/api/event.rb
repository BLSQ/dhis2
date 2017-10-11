# frozen_string_literal: true

module Dhis2
  module Api
    class Event < Base
      def id
        event
      end
      class << self
        def format_query_parameters(options)
          params = []
          params.push([:page, options[:page]])                    if options[:page]
          params.push([:pageSize, options[:page_size]])           if options[:page_size]
          params.push([:fields, format_fields(options[:fields])]) if options[:fields]
          params.concat(format_filter(options[:filter]))          if options[:filter]
          params.push([:program, options[:program]]) if options[:program]
          params.push([:orgUnit, options[:org_unit]]) if options[:org_unit]
          params.push([:trackedEntityInstance, options[:tracked_entity_instance]]) if options[:tracked_entity_instance]

          RestClient::ParamsArray.new(params)
        end

        def create(client, tuples)
          begin
            body = { resource_name.to_sym => tuples }
            response = client.post(resource_name, body)
          rescue RestClient::Conflict => e
            response = Dhis2::Client.deep_change_case(JSON.parse(e.response.body), :underscore)
          end
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
