# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module Event
        def self.included(base)
          base.extend(ClassMethods)
        end

        def id
          # we use super because id is defined on creation
          super || event
        end

        module ClassMethods
          def list(client, options = {}, raw = false)
            raise InvalidRequestError, new(list_error_message) if invalid_list_arguments?(options)
            super
          end

          private

          def additional_query_parameters
            [:program, :org_unit, :tracked_entity_instance]
          end

          def instance_creation_success?(response)
            response["status"] == "OK" &&
              response["response"] &&
              response["response"]["status"] == "SUCCESS" &&
              response["response"]["imported"] == 1 &&
              response["response"]["import_summaries"]
          end

          def created_instance_id(response)
            response["response"]["import_summaries"][0]["reference"]
          end

          def invalid_list_arguments?(options)
            %i(org_unit program tracked_entity_instance event).all? do |arg|
              options[arg].nil?
            end
          end

          def list_error_message
            "At least one of the following query parameters are required:" \
            "org_unit, program, tracked_entity_instance or event."
          end
        end
      end
    end
  end
end
