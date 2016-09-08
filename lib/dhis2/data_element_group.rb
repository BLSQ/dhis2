module Dhis2
  class DataElementGroup < Base
    def initialize(params)
      super(params)
    end

    class << self
      def create(groups)
        groups = [groups].flatten
        de_groups = {
          dataElementGroups: groups.map do |group|
            {
              name:      group[:name],
              shortName: group[:short_name],
              code:      group[:code] || group[:short_name]
            }
          end
        }
        response = Dhis2.client.post("metadata", de_groups)
        Dhis2::Status.new(response)
      end
    end
  end
end
