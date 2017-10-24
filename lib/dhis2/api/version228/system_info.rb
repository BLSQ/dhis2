# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class SystemInfo
        def self.get(client)
          client.get("/system/info")
        end
      end
    end
  end
end