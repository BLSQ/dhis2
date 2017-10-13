# frozen_string_literal: true

module Dhis2
  module Api
    class ResourceTable < Base
      class << self
        def analytics(client)
          Dhis2::Status.new(client.post("resourceTables/analytics"))
        end
      end
    end
  end
end
