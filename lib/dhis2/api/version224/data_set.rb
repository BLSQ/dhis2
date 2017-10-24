# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class DataSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version224::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:period_type).value(
            included_in?: ::Dhis2::Api::Version224::Constants.period_types
          )
        end

        def add_data_elements(new_data_element_ids)
          (new_data_element_ids - data_element_ids).each do |data_element_id|
            add_data_element(data_element_id, check: true)
          end
        end

        def add_data_element(data_element_id, check: true)
          # this returns 204 on success and failure...
          client.post("dataSets/#{id}/dataElements/#{data_element_id}", {})
          return unless check
          updated_set = self.class.find(client, id)
          if updated_set.data_element_ids.include?(data_element_id)
            self.data_elements = updated_set.data_elements
          else
            raise Dhis2::DataElementAdditionError.new("Could not add dataElement #{data_element_id}")
          end
        end

        def data_element_ids
          data_elements.map { |de| de["id"] }
        end

        private

        def self.creation_defaults(args)
          {
            code: args[:short_name],
            period_type: "Monthly"
          }
        end
      end
    end
  end
end