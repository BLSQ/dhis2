# frozen_string_literal: true

module Dhis2
  module Api
    module Version225
      class Indicator < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:short_name).filled
          required(:numerator).filled
          required(:denominator).filled
          required(:indicator_type).filled
        end
      end
    end
  end
end
