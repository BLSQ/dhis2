# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module ReportTable
        def self.included(base)
          base.extend(ClassMethods)
        end

        private

        def instance_update_success?(_response)
          # response is empty so...
          true
        end

        module ClassMethods
          private

          def created_instance_id(_response)
            nil
          end

          def instance_creation_success?(response)
            response["status"] == "OK"
          end
        end
      end
    end
  end
end
