# frozen_string_literal: true

module Dhis2
  class CollectionWrapper
    def initialize(resource_name, client)
      @klass  = get_resource_klass(resource_name, client.version)
      @client = client
    end

    def method_missing(method_name, *args, &block)
      args = args.unshift(@client)
      @klass.public_send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name)
      @klass.respond_to? method_name
    end

    private

    def get_resource_klass(resource_name, version)
      Object.const_get "Dhis2::Api::#{MAPPING[version]}::#{resource_name}"
    end

    MAPPING = {
      "2.24" => "Version224"
    }
  end
end
