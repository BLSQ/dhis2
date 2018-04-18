# frozen_string_literal: true

module Dhis2
  module Api
    module BulkCreatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def bulk_creation_status_class
           ::Dhis2::Api::ImportSummary
        end

        # args is a hash like: { data_element_groups: [{ name: "foo" }, { name: "bar" }] }
        def bulk_create(client, args, raw_input = false)
          response = client.post(path: "metadata", payload: args, raw_input: raw_input)
          bulk_creation_status_class.new(response).tap do |summary|
            unless summary.bulk_success?
              exception = Dhis2::BulkCreationError.new("Didnt create bulk of data properly.\n Response: #{response.to_json}")
              exception.import_summary = summary
              raise exception
            end
          end
        end
      end
    end
  end
end
