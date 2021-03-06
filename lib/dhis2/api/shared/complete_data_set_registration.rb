# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module CompleteDataSetRegistration
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def create(client, period:, organisation_unit:, data_set:, multi_ou: false)
            client.post(
              path:      resource_name,
              payload:   {"completeDataSetRegistrations": [{
                organisationUnit: organisation_unit,
                period:           period,
                dataSet:          data_set,
                multiOu:          multi_ou
              }]},
              raw_input: true
            )
          end

          def delete(client, period:, organisation_unit:, data_set:)
            client.delete(
              path:         resource_name,
              query_params: {
                ou: organisation_unit,
                pe: period,
                ds: data_set
              }
            )
          end

          def list(client, periods:, organisation_units:, data_sets:)
            query_params = periods.map { |p| "period=#{p}" }
            query_params += organisation_units.map { |ou| "orgUnit=#{ou}" }
            query_params += data_sets.map { |ds| "dataSet=#{ds}" }
            json_response = client.get(
              path: "#{resource_name}?#{query_params.join('&')}"
            )
            return [] unless json_response["complete_data_set_registrations"]
            json_response["complete_data_set_registrations"].map { |raw_resource| new(client, raw_resource) }
          end
        end
      end
    end
  end
end
