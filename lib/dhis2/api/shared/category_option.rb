
# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module CategoryOption
        Schema = Dry::Validation.Schema do
          required(:name).filled
        end
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
        end
      end
    end
  end
end
