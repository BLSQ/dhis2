# frozen_string_literal: true

module Dhis2
  module Api
    class DataElementGroup < Base
      class << self
        def create(client, groups)
          de_groups = {
            data_element_groups: ensure_array(groups).map do |group|
              {
                name:       group[:name],
                short_name: group[:short_name],
                code:       group[:code] || group[:short_name]
              }.tap do |mapped_group|
                if group[:data_elements]
                  mapped_group[:data_elements] = group[:data_elements].map do |element|
                    { id: element[:id] }
                  end
                end
              end
            end
          }
          Dhis2::Status.new(client.post("metadata", de_groups))
        end
      end
    end
  end
end
