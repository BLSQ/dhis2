# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class CategoryCombo < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator
        include ::Dhis2::Api::Shared::CategoryCombo

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:data_dimension_type).value(
            included_in?: ::Dhis2::Api::Version224::Constants.data_dimension_types
          )
        end
      end
    end
  end
end
