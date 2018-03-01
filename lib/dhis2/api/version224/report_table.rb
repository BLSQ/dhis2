# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class ReportTable < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator
        include ::Dhis2::Api::Shared::ReportTable

        Schema = Dry::Validation.Schema do
          required(:name).filled
        end
      end
    end
  end
end
