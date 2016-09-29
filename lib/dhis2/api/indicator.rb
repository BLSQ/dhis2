module Dhis2
  module Api
    class Indicator < Base
      class << self
        def create(client, elements)
          elements          = [elements].flatten
          category_combo_id = client.category_combos.find_by(name: "default").id

          indicator = {
            indicators: elements.map do |element|
              {
                name:             element[:name],
                short_name:       element[:short_name],
                code:             element[:code] || element[:short_name],
                domain_type:      element[:domain_type] || "AGGREGATE",
                indicator_type:   element[:indicator_type] || "NUMBER",
                aggregation_type: element[:aggregation_type] || "SUM",
                type:             element[:type] || "int", # for backward compatbility
                aggregation_operator: element[:aggregation_type] || "SUM", # for backward compatbility
                category_combo:   { id: category_combo_id }
              }
            end
          }

          response = client.post("metadata", indicator)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
