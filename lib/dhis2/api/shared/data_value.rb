# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module DataValue
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def find(client, period:, organisation_unit:, data_element:)
            client.get(
              path: resource_name,
              query_params: {
                pe: period,
                ou: organisation_unit,
                de: data_element
              }
            ).first
          end
        end
      end
    end
  end
end
