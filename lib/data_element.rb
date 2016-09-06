require "base"

module Dhis2
  class DataElement < Base
    attr_reader :id, :display_name

    def initialize(params)
      super(params)
    end

    class << self
      def create(elements)
        elements = [elements].flatten
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
        json_response = Dhis2.resource["metadata"].post(
          JSON.generate(data_element),
          content_type: "application/json"
        )
        response = JSON.parse(json_response)
        Dhis2::Status.new(response)
      end
    end
  end
end
