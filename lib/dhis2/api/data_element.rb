module Dhis2
  module Api
    class DataElement < Base
      class << self
        def create(client, elements)
          elements          = [elements].flatten
          category_combo_id = client.category_combos.find_by(name: "default").id

          data_element = {
            data_elements: elements.map do |element|
              {
                name:             element[:name],
                short_name:       element[:short_name],
                code:             element[:code] || element[:short_name],
                domain_type:      element[:domain_type] || "AGGREGATE",
                value_type:       element[:value_type] || "NUMBER",
                aggregation_type: element[:aggregation_type] || "SUM",
                aggregation_operator: element[:aggregation_type] || "SUM",
                category_combo:   { id: category_combo_id }
              }
            end
          }

          response = client.post("metadata", data_element)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
