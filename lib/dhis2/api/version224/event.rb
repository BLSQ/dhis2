# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class Event < ::Dhis2::Api::Base
        class InvalidRequestError < Dhis2::Error; end
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator

        # args for a program without registration
        Schema = Dry::Validation.Schema do
          required(:program).filled  # program must be linked to the org unit
          required(:org_unit).filled
          required(:event_date).filled
          required(:program_stage).filled
          required(:data_values).each do
            required(:data_element).filled
            required(:value).filled
          end
        end

        def id
          # we use super because id is defined on creation
          super || event
        end

        def self.list(client, options = {})
          if invalid_list_arguments?(options)
            raise InvalidRequestError,new(list_error_message)
          end
          super(client, options)
        end

        private

        def self.instance_creation_success?(response)
          response["status"] == "OK" &&
          response["response"] &&
          response["response"]["status"] == "SUCCESS" &&
          response["response"]["imported"] == 1 &&
          response["response"]["import_summaries"]
        end

        def self.created_instance_id(response)
          response["response"]["import_summaries"][0]["reference"]
        end

        def self.additional_query_parameters
          [:program, :org_unit, :tracked_entity_instance]
        end

        def self.invalid_list_arguments?(options)
          %i(org_unit program tracked_entity_instance event).all? do |arg|
            options[arg].nil?
          end
        end

        def self.list_error_message
          "At least one of the following query parameters are required:" \
          "org_unit, program, tracked_entity_instance or event."
        end
      end
    end
  end
end