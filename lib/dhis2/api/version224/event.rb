# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class Event < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable

        def id
          event
        end

        def self.additional_query_parameters
          [:program, :org_unit, :tracked_entity_instance]
        end

        def self.create(client, tuples)
          begin
            response = client.post(resource_name, resource_name.to_sym => tuples)
          rescue RestClient::Conflict => e
            response = Dhis2::Case.deep_change(JSON.parse(e.response.body), :underscore)
          end
          Dhis2::Status.new(response)
        end
      end
    end
  end
end