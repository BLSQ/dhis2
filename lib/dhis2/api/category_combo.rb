module Dhis2
  module Api
    class CategoryCombo < Base
      class << self
        def defaut
          find_by(name: "default")
        end

        def create(client, combos)
          combos = [combos].flatten
          category_combo = {
            categoryCombos: combos.map do |combo|
              {
                name:                combo[:name],
                data_dimension_type: combo[:aggregation_type] || "DISAGGREGATION"
              }
            end
          }

          response = client.post("metadata", category_combo)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
