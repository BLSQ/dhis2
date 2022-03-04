
# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module CategoryOption
        Schema = Dry::Schema.define do
          required(:name).filled
        end
        def self.included(base)
          base.extend(ClassMethods)
        end

        def default
          self.class.default(client)
        end

        module ClassMethods
          def default(client)
            find_by(client, {name: "default"})
          end
        end
      end
    end
  end
end
