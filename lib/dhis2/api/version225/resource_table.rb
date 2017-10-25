# frozen_string_literal: true

module Dhis2
  module Api
    module Version225
      class ResourceTable
        def self.analytics(client)
          client.post("resourceTables/analytics")
        end
      end
    end
  end
end
