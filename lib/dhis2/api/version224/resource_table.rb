# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class ResourceTable
        def self.analytics(client)
          client.post("resourceTables/analytics")
        end
      end
    end
  end
end