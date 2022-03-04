# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class DataValueSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Version224::SaveValidator
        include ::Dhis2::Api::Shared::DataValueSet

        Schema = Dry::Schema.define do
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
