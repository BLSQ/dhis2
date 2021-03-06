# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class Event < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator
        include ::Dhis2::Api::Shared::Event

        BulkCreationStatusClass = ::Dhis2::Api::EventCreationStatus

        # args for a program without registration
        # and a  program with a program_stage
        Schema = Dry::Validation.Schema do
          required(:program).filled # program must be linked to the org unit
          required(:org_unit).filled
          required(:event_date).filled
          required(:data_values).each do
            required(:data_element).filled
            required(:value).filled
          end
        end
      end
    end
  end
end
