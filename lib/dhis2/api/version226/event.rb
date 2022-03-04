# frozen_string_literal: true

module Dhis2
  module Api
    module Version226
      class Event < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::Event

        def bulk_creation_status_class
          ::Dhis2::Api::EventCreationStatus
        end

        # args for a program without registration
        # and a  program with a program_stage
        Schema = Dry::Schema.define do
          required(:program).filled # program must be linked to the org unit
          required(:org_unit).filled
          required(:event_date).filled
          required(:data_values).array(:hash) do
            required(:data_element).filled
            required(:value).filled
          end
        end
      end
    end
  end
end
