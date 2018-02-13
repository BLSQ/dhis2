# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module DataValueSet
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def list(client, options = {}, raw = false)
            response = super(client, options, raw)
            if raw
              response["dataValues"]
            else
              response["data_values"].map do |elt|
                OpenStruct.new(elt)
              end
            end
          end

          def bulk_create(client, args, raw_input = false)
            response = client.post(path: resource_name, payload: args, raw_input: raw_input)
            ::Dhis2::Api::ImportSummary.new(response).tap do |summary|
              raise Dhis2::CreationError, "Didnt create bulk of data properly.\n Response: #{response.to_json}" unless summary.bulk_success?
            end
          end

          private

          def instance_creation_success?(response)
            Dhis2::Api::ImportSummary.new(response).creation_success?
          end

          def created_instance_id(_response)
            nil
          end

          def paginated
            false
          end

          def additional_query_parameters
            [
              :data_set, :data_element_group, :period, :start_date, :end_date,
              :org_unit, :children, :org_unit_group
            ]
          end
        end
      end
    end
  end
end
