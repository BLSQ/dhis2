# frozen_string_literal: true
module Dhis2
  module Api
    class DataElementGroup < Base
      class << self
        def create(client, groups)
          groups = [groups].flatten
          de_groups = {
            data_element_groups: groups.map do |group|
              mapped_group = {
                name:       group[:name],
                short_name: group[:short_name],
                code:       group[:code] || group[:short_name]
              }

              if group[:data_elements]
                data_elements = group[:data_elements].map do |element|
                  { id: element[:id] }
                end
                mapped_group[:data_elements] = data_elements
              end
              mapped_group
            end
          }
          response = client.post("metadata", de_groups)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
