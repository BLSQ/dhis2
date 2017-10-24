# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class DataValueSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Version228::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:data_values).each do
            schema do
              required(:value).filled
              required(:period).filled
              required(:org_unit).filled
              required(:data_element).filled
            end
          end
        end

        private

        def self.instance_creation_success?(response)
          Dhis2::Api::ImportSummary.new(response).creation_success?
        end

        def self.created_instance_id(response)
          nil
        end

        def self.paginated
          false
        end

        def self.additional_query_parameters
          [
            :data_set, :data_element_group, :period, :start_date, :end_date,
            :org_unit, :children, :org_unit_group
          ]
        end
      end
    end
  end
end