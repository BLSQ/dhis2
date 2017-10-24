# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module DataValueSet
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          private

          def instance_creation_success?(response)
            Dhis2::Api::ImportSummary.new(response).creation_success?
          end

          def created_instance_id(response)
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
