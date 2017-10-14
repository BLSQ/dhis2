# frozen_string_literal: true

module Dhis2
  module Api
    class CategoryCombo < Base
      class << self
        def default(client = Dhis2.client)
          find_by(client, name: "default")
        end

        def create(client, combos, query_params = { preheat_cache: false })
          category_combo = {
            categoryCombos: ensure_array(combos).map do |combo|
              {
                name:                combo[:name],
                data_dimension_type: combo.fetch(:aggregation_type, "DISAGGREGATION")
              }
            end
          }

          Dhis2::Status.new(client.post("metadata", category_combo, Dhis2::Case.deep_change(query_params, :camelize)))
        end
      end
    end
  end
end
