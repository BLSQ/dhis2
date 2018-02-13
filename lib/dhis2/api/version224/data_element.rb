# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class DataElement < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:short_name).filled
          required(:aggregation_type).value(
            included_in?: ::Dhis2::Api::Version224::Constants.aggregation_types
          )
          required(:domain_type).value(
            included_in?: ::Dhis2::Api::Version224::Constants.domain_types
          )
          required(:value_type).value(
            included_in?: ::Dhis2::Api::Version224::Constants.value_types
          )
          required(:category_combo).schema do
            required(:id).filled
          end
        end

        def self.creation_defaults(args)
          {
            aggregation_type:    "SUM",
            code:                args[:short_name],
            domain_type:         "AGGREGATE",
            type:                "int",
            value_type:          "NUMBER",
            zero_is_significant: true
          }
        end
      end
    end
  end
end
