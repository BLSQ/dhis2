# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module DataSet
        def add_data_elements(new_data_element_ids)
          (new_data_element_ids - data_element_ids).tap do |additions|
            (new_data_element_ids - data_element_ids).each do |data_element_id|
              data_set_elements.push({ "data_element" => { "id" => data_element_id } })
            end
            update if additions.any?
          end
        end

        def data_element_ids
          data_set_elements.map { |elt| elt["data_element"]["id"] }
        end
      end
    end
  end
end