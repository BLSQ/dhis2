# frozen_string_literal: true

module Dhis2
  module Api
    module Listable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def list(client, options = {})
          json_response = client.get(resource_name, format_query_parameters(options))
          if paginated
            PaginatedArray.new(
              json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
              json_response["pager"]
            )
          else
            json_response
          end
        end

        private

        def paginated
          true
        end

        def format_query_parameters(options)
          ::Dhis2::QueryParametersFormatter.new(
            options: options,
            query_parameters: query_parameters
          ).call
        end

        def query_parameters
          default_query_parameters + additional_query_parameters
        end

        def additional_query_parameters
          []
        end

        def default_query_parameters
          [:page, :page_size]
        end
      end
    end
  end
end
