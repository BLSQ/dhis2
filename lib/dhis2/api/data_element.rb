# frozen_string_literal: true

module Dhis2
  module Api
    class DataElement < Base
      class << self
        def create(client, elements, query_params = { preheat_cache: false })
          elements = [elements].flatten
          category_combo = client.category_combos.find_by(name: "default")

          data_element = {
            data_elements: elements.map do |element|
              {
                name:                 element[:name],
                short_name:           element[:short_name],
                code:                 element[:code] || element[:short_name],
                domain_type:          element[:domain_type] || "AGGREGATE",
                value_type:           element[:value_type] || "NUMBER",
                aggregation_type:     element[:aggregation_type] || "SUM",
                type:                 element[:type] || "int", # for backward compatbility
                aggregation_operator: element[:aggregation_type] || "SUM", # for backward compatbility
                category_combo:       { id: category_combo.id, name: category_combo.name }
              }
            end
          }

          response = client.post("metadata", data_element, client.class.deep_change_case(query_params, :camelize))
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
