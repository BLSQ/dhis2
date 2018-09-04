
# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module Category
        def self.included(base)
          base.extend(ClassMethods)
        end

        def default
          self.class.default(client)
        end        

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:data_dimension_type).value(
            included_in?: ::Dhis2::Api::Constants::DATA_DIMENSION_TYPES
          )
        end

        module ClassMethods
          def resource_name
            "categories"
          end
          def default(client)
            find_by(client, name: "default")
          end          
          def creation_defaults(args)
            {
              data_dimension_type: "DISAGGREGATION"
            }
          end
        end
      end
    end
  end
end
