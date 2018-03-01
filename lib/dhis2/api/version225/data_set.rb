# frozen_string_literal: true

module Dhis2
  module Api
    module Version225
      class DataSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::DataSet

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:period_type).value(
            included_in?: ::Dhis2::Api::Version225::Constants.period_types
          )
          required(:category_combo).schema do
            required(:id).filled
          end
        end

        def self.creation_defaults(args)
          {
            code:        args[:short_name],
            period_type: "Monthly"
          }
        end
      end
    end
  end
end
