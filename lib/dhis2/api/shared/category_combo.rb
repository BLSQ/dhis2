# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module CategoryCombo
        def self.included(base)
          base.extend(ClassMethods)
        end

        def default
          self.class.default(client)
        end

        module ClassMethods
          def default(client)
            find_by(client, name: "default")
          end

          private

          def creation_defaults(_args)
            { data_dimension_type: "DISAGGREGATION" }
          end
        end
      end
    end
  end
end
