# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module CompleteDataSetRegistration
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def create(client, period:, organisation_unit:, data_set: )
            client.post(
              path: resource_name,
              query_params: {
                ou: organisation_unit,
                pe: period,
                ds: data_set
              }
            )
          end

          def delete(client, period:, organisation_unit:, data_set:)
            client.delete(
              path: resource_name,
              query_params: {
                ou: organisation_unit,
                pe: period,
                ds: data_set
              }
            )
          end

          def list(client, periods:, organisation_units:, data_sets:)
            client.get(
              path: resource_name,
              query_params: {
                orgUnit: organisation_units,
                period: periods,
                dataSet: data_sets
              }
            )
          end
        end        
      end
    end
  end
end
