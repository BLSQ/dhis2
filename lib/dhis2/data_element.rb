module Dhis2
  class DataElement < Base
    class << self
      def create(elements)
        elements          = [elements].flatten
        category_combo_id = CategoryCombo.find_by(name: "default").id

        data_element = {
          dataElements: elements.map do |element|
            {
              name:            element[:name],
              shortName:       element[:short_name],
              code:            element[:code] || element[:short_name],
              domainType:      element[:domain_type] || "AGGREGATE",
              valueType:       element[:value_type] || "NUMBER",
              aggregationType: element[:aggregation_type] || "SUM",
              categoryCombo:   { id: category_combo_id }
            }
          end
        }

        response = Dhis2.client.post("metadata", data_element)
        Dhis2::Status.new(response)
      end
    end
  end
end
