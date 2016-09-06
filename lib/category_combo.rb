require "base"

module Dhis2
  class CategoryCombo < Base
    attr_reader :id, :display_name

    def initialize(params)
      super(params)
    end

    class << self
      def defaut
        find_by(name: "default")
      end
      
      def create(combos)
        combos = [combos].flatten
        category_combo = {
          categoryCombos: combos.map do |combo|
            {
              name:            combo[:name],
              dataDimensionType: combo[:aggregation_type] || "DISAGGREGATION"
            }
          end
        }
        json_response = Dhis2.resource["metadata"].post(
          JSON.generate(category_combo),
          content_type: "application/json"
        )
        response = JSON.parse(json_response)

        Dhis2::Status.new(response)
      end
    end
  end
end
