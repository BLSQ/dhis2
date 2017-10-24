# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module SaveValidator
        def self.included(base)
          base.extend(ClassMethods)
        end

        private

        def validate_instance_update(response)
          unless instance_update_success?(response)
            raise Dhis2::UpdateError.new "Update error. #{ response }"
          end
        end

        def instance_update_success?(response)
          self.class.base_response_check(response) &&
          response["http_status"] == "OK"
        end

        module ClassMethods
          def validate_instance_creation(response)
            unless instance_creation_success?(response)
              raise Dhis2::CreationError.new "Creation error. #{ response }"
            end
          end

          def instance_creation_success?(response)
            base_response_check(response) &&
            response["http_status"] == "Created"
          end

          def created_instance_id(response)
            response["response"]["uid"]
          end

          def base_response_check(response)
            response["status"] == "OK"
          end
        end
      end
    end
  end
end
