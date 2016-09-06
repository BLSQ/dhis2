module Dhis2
  class CategoryCombo < Base
    class << self
      def defaut
        find_by(name: "default")
      end

      def create(combos)
        combos = [combos].flatten
        category_combo = {
          categoryCombos: combos.map do |combo|
            {
              name:              combo[:name],
              dataDimensionType: combo[:aggregation_type] || "DISAGGREGATION"
            }
          end
        }

        response = Dhis2.client.post("metadata", category_combo)
        Dhis2::Status.new(response)
      end
    end
  end
end
