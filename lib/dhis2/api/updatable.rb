# frozen_string_literal: true

module Dhis2
  module Api
    module Updatable
      def update_attributes(attributes)
        client.patch("#{self.class.resource_name}/#{id}", attributes)
        attributes.each do |key, value|
          public_send("#{key}=", value)
        end
        self
      end

      def update
        client.put("#{self.class.resource_name}/#{id}", update_args).tap do |response|
          validate_instance_update(response)
        end
      end

      private

      def update_args
        to_h.reject { |k, _| k == :client }
      end
    end
  end
end
