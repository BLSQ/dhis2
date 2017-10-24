# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module Constants
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def data_dimension_types
            ::Dhis2::Api::Constants::DATA_DIMENSION_TYPES
          end

          def domain_types
            ::Dhis2::Api::Constants::DOMAIN_TYPES
          end

          def feature_types
            ::Dhis2::Api::Constants::DATA_DIMENSION_TYPES
          end

          def period_types
            ::Dhis2::Api::Constants::PERIOD_TYPES
          end

          def program_types
            ::Dhis2::Api::Constants::PROGRAM_TYPES
          end
        end
      end
    end
  end
end

