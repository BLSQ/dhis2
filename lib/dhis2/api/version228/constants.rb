# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      module Constants
        VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE URL LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE AGE PHONE_NUMBER)
        AGGREGATION_TYPES = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)


        def self.value_types
          VALUE_TYPES
        end

        def self.aggregation_types
          AGGREGATION_TYPES
        end

        def self.data_dimension_types
          ::Dhis2::Api::Constants::DATA_DIMENSION_TYPES
        end

        def self.domain_types
          ::Dhis2::Api::Constants::DOMAIN_TYPES
        end

        def self.feature_types
          ::Dhis2::Api::Constants::DATA_DIMENSION_TYPES
        end

        def self.period_types
          ::Dhis2::Api::Constants::PERIOD_TYPES
        end

        def self.program_types
          ::Dhis2::Api::Constants::PROGRAM_TYPES
        end
      end
    end
  end
end
