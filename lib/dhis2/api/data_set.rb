# frozen_string_literal: true
module Dhis2
  module Api
    class DataSet < Base
      class << self
        def create(client, sets)
          sets = [sets].flatten

          category_combo = client.category_combos.find_by(name: "default")

          data_set = {
            data_sets: sets.map do |set|
              dataset = {
                name:               set[:name],
                short_name:         set[:short_name],
                code:               set[:code],
                period_type:        "Monthly",
                data_elements:  set[:data_element_ids] ? set[:data_element_ids].map { |id| { id: id } } : [],
                organisation_units: set[:organisation_unit_ids] ? set[:organisation_unit_ids].map { |id| { id: id } } : [],
                category_combo:     { id: category_combo.id, name: category_combo.name }
              }

              dataset
            end
          }
          response = client.post("metadata", data_set)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
