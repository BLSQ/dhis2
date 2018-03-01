# frozen_string_literal: true

module Dhis2
  module Api
    module Listable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        PAGER_KEY = "pager"

        def list(client, options = {}, raw = false)
          json_response = client.get(path: resource_name, query_params: format_query_parameters(options), raw: raw)
          if paginated
            if raw
              PaginatedArray.new(
                json_response[resource_name],
                json_response[PAGER_KEY]
              )
            else
              PaginatedArray.new(
                json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
                json_response[PAGER_KEY]
              )
            end
          else
            json_response
          end
        end

        def fetch_paginated_data(client, params = {}, options = {})
          raise InvalidMethodError, "this collection is not paginated" unless paginated
          options = { raw: false, with_pager: false }.merge(options)
          Enumerator.new do |yielder|
            params[:page] ||= 1
            loop do
              results = list(client, params, options[:raw])
              if options[:with_pager]
                results.map { |item| yielder << [item, results.pager] }
              else
                results.map { |item| yielder << item }
              end
              raise StopIteration if results.pager.last_page?
              params[:page] += 1
            end
          end
        end

        def paginated
          true
        end

        private

        def format_query_parameters(options)
          ::Dhis2::QueryParametersFormatter.new(
            options:          options,
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
          [:page, :page_size, :root_junction]
        end
      end
    end
  end
end
