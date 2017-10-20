# frozen_string_literal: true

module Dhis2
  module Api
    class Base < OpenStruct
      class << self
        def resource_key
          Dhis2::Case.underscore(resource_name)
        end

        def resource_name
          simple_name = name.split("::").last
          simple_name[0].downcase + simple_name[1..-1] + "s"
        end
      end

      def initialize(client, raw_data)
        super(raw_data)

        self.client = client
      end

      def ==(other)
        self.class == other.class && id == other.id
      end
    end
  end
end
