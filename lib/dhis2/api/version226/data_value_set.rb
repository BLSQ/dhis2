# frozen_string_literal: true

module Dhis2
  module Api
    module Version226
      class DataValueSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::DataValueSet

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
      end
    end
  end
end