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
              if response["data_values"]
                response["data_values"].map do |elt|
                  OpenStruct.new(elt)
                end
              else
                []
              end
            end
          end

          def bulk_create(client, args, raw_input = false)
            response = client.post(path: resource_name, payload: args, raw_input: raw_input)
            ::Dhis2::Api::ImportSummary.new(response).tap do |summary|
              unless summary.bulk_success?
                exception = Dhis2::BulkCreationError.new("Didnt create bulk of data properly.\n Response: #{response.to_json}")
                exception.import_summary = summary
                raise exception
              end
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
            %i[
              data_set data_element_group period
              org_unit children org_unit_group
            ]
          end
        end
      end
    end
  end
end
