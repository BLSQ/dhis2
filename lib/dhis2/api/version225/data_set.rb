# frozen_string_literal: true

module Dhis2
  module Api
    module Version225
      class DataSet < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version225::SaveValidator

        class DataElementAdditionError < Dhis2::Error; end

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:period_type).value(
            included_in?: ::Dhis2::Api::Version225::Constants.period_types
          )
          required(:category_combo).schema do
            required(:id).filled
          end
        end

        def add_data_elements(new_data_element_ids)
          (new_data_element_ids - data_element_ids).tap do |additions|
            (new_data_element_ids - data_element_ids).each do |data_element_id|
              data_set_elements.push({ "data_element" => { "id" => data_element_id } })
            end
            update if additions.any?
          end
        end

        def data_element_ids
          data_set_elements.map { |elt| elt["data_element"]["id"] }
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