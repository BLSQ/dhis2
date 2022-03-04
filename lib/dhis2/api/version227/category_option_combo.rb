# frozen_string_literal: true

module Dhis2
  module Api
    module Version227
      class CategoryOptionCombo < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::CategoryOptionCombo

        Schema = Dry::Schema.define do
          required(:category_combo).schema do
            required(:id).filled
          end
        end
      end
    end
  end
end
