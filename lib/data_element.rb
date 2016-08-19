require "base"

module Dhis2
  class DataElement < Base
    attr_reader :id, :display_name

    def initialize(params)
      super(params)
      @id = params["id"]
      @display_name = params["displayName"]
    end

    class << self
      def list(options = {})
        response = Dhis2.get_resource("dataElements", options).get
        json_response = JSON.parse(response)
        PaginatedArray.new(json_response["dataElements"].map { |raw_data_element| self.new(raw_data_element) }, json_response["pager"])
      end

      def find(id)
        response = Dhis2.resource["dataElements/#{id}"].get
        json_response = JSON.parse(response)
        self.new(json_response)
      end

      def create(elements)
        category_combo_id = JSON.parse(Dhis2.resource["categoryCombos"].get)["categoryCombos"].first["id"]
        data_element = {
          dataElements: elements.map do |element|
            {
              name: element[:name],
              shortName: element[:short_name],
              code: element[:code] || element[:short_name],
              domainType: element[:domain_type] || "AGGREGATE",
              valueType: element[:value_type] || "INTEGER_POSITIVE",
              aggregationType: element[:aggregation_type] || "SUM",
              categoryCombo: { id: category_combo_id }
            }
          end
        }
        json_response = Dhis2.resource["metadata"].post(JSON.generate(data_element), content_type: "application/json")
        response = JSON.parse(json_response)

        Dhis2::Status.new(response)
    end
    end
  end
end
