# frozen_string_literal: true

module Dhis2
  module Api
    module Constants
      DATA_DIMENSION_TYPES = %w(ATTRIBUTE DISAGGREGATION).freeze
      DOMAIN_TYPES  = %w(TRACKER AGGREGATE).freeze
      FEATURE_TYPES = %w(SYMBOL POLYGON MULTI_POLYGON NONE POINT).freeze
      PERIOD_TYPES  = %w(Daily Weekly Monthly BiMonthly Quarterly SixMonthly Yearly).freeze
      PROGRAM_TYPES = %w(WITHOUT_REGISTRATION WITH_REGISTRATION).freeze
    end
  end
end
