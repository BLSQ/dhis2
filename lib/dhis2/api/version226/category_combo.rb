# frozen_string_literal: true

module Dhis2
  module Api
    module Version226
      class CategoryCombo < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::CategoryCombo

        Schema = Dry::Schema.define do
          required(:name).filled
          required(:data_dimension_type).value(
            included_in?: ::Dhis2::Api::Version226::Constants.data_dimension_types
          )
        end
      end
    end
  end
end
