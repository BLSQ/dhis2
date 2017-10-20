# frozen_string_literal: true

module Dhis2
  module Api
    module Constants
      DATA_DIMENSION_TYPES = %w(ATTRIBUTE DISAGGREGATION)
      DOMAIN_TYPES  = %w(TRACKER AGGREGATE)
      FEATURE_TYPES = %w(SYMBOL POLYGON MULTI_POLYGON NONE POINT)
      PERIOD_TYPES  = %w(Daily Weekly Monthly BiMonthly Quarterly SixMonthly Yearly)
      PROGRAM_TYPES = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)
    end
  end
end
