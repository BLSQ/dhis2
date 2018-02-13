# frozen_string_literal: true

module Dhis2
  module Api
    module Creatable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def create(client, args, raw_input = false)
          if raw_input
            client.post(path: resource_name, payload: args, raw_input: true).tap do |response|
              validate_instance_creation(response)
            end
          else
            args = creation_args(args)
            with_valid_args(args) do
              response = client.post(path: resource_name, payload: args)
              validate_instance_creation(response)
              new(client, args.merge(id: created_instance_id(response)))
            end
          end
        end

        private

        def creation_defaults(_args)
          {}
        end

        def creation_args(args)
          creation_defaults(args).merge(args).keep_if { |_, v| !v.nil? }
        end

        def with_valid_args(args)
          validator = self::Schema.call(args)
          if validator.success?
            yield
          else
            raise Dhis2::CreationError, "Validation Error: #{validator.messages}"
          end
        end
      end
    end
  end
end
