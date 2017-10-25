# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module SystemInfo
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def get(client)
            client.get("/system/info")
          end
        end
      end
    end
  end
end
