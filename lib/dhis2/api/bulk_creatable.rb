# frozen_string_literal: true

module Dhis2
  module Api
    module BulkCreatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # args is a hash like: { data_element_groups: [{ name: "foo" }, { name: "bar" }] }
        def bulk_create(client, args, raw_input = false)
          response = client.post(path: "metadata", payload: args, raw_input: raw_input)
          ::Dhis2::Api::ImportSummary.new(response).tap do |summary|
            raise Dhis2::CreationError, "Didnt create bulk of data properly.\n Response: #{response.to_json}" unless summary.bulk_success?
          end
        end
      end
    end
  end
end
