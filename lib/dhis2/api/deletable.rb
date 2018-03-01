# frozen_string_literal: true

module Dhis2
  module Api
    module Deletable
      def delete
        client.delete(path: "#{self.class.resource_name}/#{id}")
        true
      end
    end
  end
end
