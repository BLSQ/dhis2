# frozen_string_literal: true

module Dhis2
  module Api
    class DataElement < Base
      class << self
        def create(client, elements, query_params = { preheat_cache: false })
          category_combo = client.category_combos.find_by(name: "default")

          data_element = {
            data_elements: ensure_array(elements).map do |element|
              {
                name:                 element[:name],
                short_name:           element[:short_name],
                code:                 element[:code] || element[:short_name],
                domain_type:          element.fetch(:domain_type, "AGGREGATE"),
                value_type:           element.fetch(:value_type, "NUMBER"),
                aggregation_type:     element.fetch(:aggregation_type, "SUM"),
                type:                 element.fetch(:type, "int"), # for backward compatbility
                aggregation_operator: element.fetch(:aggregation_type, "SUM"), # for backward compatbility
                zero_is_significant:  element.fetch(:zero_is_significant, true),
                category_combo:       { id: category_combo.id, name: category_combo.name }
              }
            end
          }

          response = client.post("metadata", data_element, Dhis2::Utils.deep_change_case(query_params, :camelize))
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
