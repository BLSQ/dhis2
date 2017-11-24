# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module DataElementGroup
        def self.included(base)
          base.extend(ClassMethods)
        end

        def data_element_ids
          data_elements.map { |elt| elt["id"] }
        end

        module ClassMethods
          def creation_defaults(args)
            {
              code: args[:short_name]
            }
          end
        end
      end
    end
  end
end
