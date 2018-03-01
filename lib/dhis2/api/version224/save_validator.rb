# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      module SaveValidator
        def self.included(base)
          base.extend(ClassMethods)
        end

        private

        def validate_instance_update(response)
          unless instance_update_success?(response)
            raise Dhis2::UpdateError, "Update error. #{response}"
          end
        end

        def instance_update_success?(response)
          self.class.base_response_check(response) &&
            Dhis2::Api::ImportSummary.new(response["response"]).update_success?
        end

        module ClassMethods
          def validate_instance_creation(response)
            unless instance_creation_success?(response)
              raise Dhis2::CreationError, "Creation error. #{response}"
            end
          end

          def instance_creation_success?(response)
            base_response_check(response) &&
              Dhis2::Api::ImportSummary.new(response["response"]).creation_success?
          end

          def created_instance_id(response)
            response["response"]["last_imported"]
          end

          def base_response_check(response)
            response["status"] == "OK" &&
              response["response"]
          end
        end
      end
    end
  end
end
