# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module ResourceTable
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def analytics(client)
            client.post("resourceTables/analytics")
          end
        end
      end
    end
  end
end
