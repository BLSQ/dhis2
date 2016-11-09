module Dhis2
  module Api
    class SystemInfo < Base
      class << self
        def get(client)
          client.get("/system/info")
        end
      end
    end
  end
end
