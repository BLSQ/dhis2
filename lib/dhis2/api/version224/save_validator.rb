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
            raise "Update error. #{ response }"
          end
        end

        def instance_update_success?(response)
          self.class.base_response_check(response) &&
          response["response"]["import_count"]["updated"] == 1
        end

        module ClassMethods
          def validate_instance_creation(response)
            unless instance_creation_success?(response)
              raise "Creation error. #{ response }"
            end
          end

          def instance_creation_success?(response)
            base_response_check(response) &&
            response["response"]["import_count"]["imported"] == 1
          end

          def created_instance_id(response)
            response["response"]["last_imported"]
          end

          def base_response_check(response)
            response["status"] == "OK" &&
            response["response"] &&
            response["response"]["status"] == "SUCCESS" &&
            response["response"]["import_count"]
          end
        end
      end
    end
  end
end
