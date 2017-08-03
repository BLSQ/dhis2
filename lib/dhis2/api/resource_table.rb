# frozen_string_literal: true

module Dhis2
  module Api
    class ResourceTable < Base
      class << self
        def analytics(client)
          response = client.post("resourceTables")
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
