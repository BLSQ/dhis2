require "base"

module Dhis2
  class DataElementGroup < Base
    attr_reader :id, :display_name, :display_short_name

    def initialize(params)
      super(params)
    end

    class << self
      def create(groups)
        groups = [groups].flatten

        dhis2_groups = {
          dataElementGroups: groups.map do |group|
            {
              name:            group[:name],
              shortName:       group[:short_name],
              code:            group[:code] || group[:short_name]
            }
          end
        }
        json_response = Dhis2.resource["metadata"].post(
          JSON.generate(dhis2_groups),
          content_type: "application/json"
        )
        response = JSON.parse(json_response)

        Dhis2::Status.new(response)
      end
    end
    
    def add(data_element)
        json_response = Dhis2.resource["dataElementGroup/#{id}/#{data_element.id}"].post(
          "{}", content_type: "application/json"
        )
        response = JSON.parse(json_response)

        Dhis2::Status.new(response)
    end 
  end
end
