module Dhis2
  module Api
    class DataElementGroup < Base
      class << self
        def create(client, groups)
          groups = [groups].flatten
          de_groups = {
            data_element_groups: groups.map do |group|
              {
                name:       group[:name],
                short_name: group[:short_name],
                code:       group[:code] || group[:short_name]
              }
            end
          }
          response = client.post("metadata", de_groups)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
