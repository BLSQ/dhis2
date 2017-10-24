# frozen_string_literal: true

module Dhis2
  module Api
    module Version227
      module Constants
        include ::Dhis2::Api::Shared::Constants

        VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE URL LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE AGE PHONE_NUMBER)
        AGGREGATION_TYPES = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)

        def self.value_types
          VALUE_TYPES
        end

        def self.aggregation_types
          AGGREGATION_TYPES
        end
      end
    end
  end
end
