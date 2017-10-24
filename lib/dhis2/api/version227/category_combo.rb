# frozen_string_literal: true

module Dhis2
  module Api
    module Version227
      class CategoryCombo < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version227::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:data_dimension_type).value(
            included_in?: ::Dhis2::Api::Version227::Constants.data_dimension_types
          )
        end

        def default
          self.class.default(client)
        end

        def self.default(client)
          find_by(client, name: "default")
        end

        private

        def self.creation_defaults(args)
          { data_dimension_type: "DISAGGREGATION" }
        end
      end
    end
  end
end