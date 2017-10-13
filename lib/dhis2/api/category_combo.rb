# frozen_string_literal: true

module Dhis2
  module Api
    class CategoryCombo < Base
      class << self
        def defaut
          find_by(name: "default")
        end

        def create(client, combos)
          category_combo = {
            categoryCombos: ensure_array(combos).map do |combo|
              {
                name:                combo[:name],
                data_dimension_type: combo.fetch(:aggregation_type, "DISAGGREGATION")
              }
            end
          }

          Dhis2::Status.new(client.post("metadata", category_combo))
        end
      end
    end
  end
end
