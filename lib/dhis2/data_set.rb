module Dhis2
  class DataSet < Base
    def initialize(params)
      super(params)
    end

    class << self
      def create(sets)
        sets     = [sets].flatten
        data_set = {
          dataSets: sets.map do |set|
            {
              name:              set[:name],
              shortName:         set[:short_name],
              code:              set[:code],
              periodType:        "Monthly",
              dataElements:      set[:data_element_ids] ? set[:data_element_ids].map { |id| { id: id } } : [],
              organisationUnits: set[:organisation_unit_ids] ? set[:organisation_unit_ids].map { |id| { id: id } } : []
            }
          end
        }
        response = Dhis2.client.post("metadata", data_set)
        Dhis2::Status.new(response)
      end
    end
  end
end
