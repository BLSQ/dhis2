# frozen_string_literal: true

module Dhis2
  class CollectionWrapper
    def initialize(resource_name, client)
      @klass  = get_resource_klass(resource_name)[client.version]
      @client = client
    end

    def method_missing(method_name, *args, **kwargs, &block)
      args = args.unshift(@client)
      @klass.public_send(method_name, *args, **kwargs, &block)
    end

    def respond_to_missing?(method_name)
      @klass.respond_to? method_name
    end

    private

    def get_resource_klass(resource_name)
      Object.const_get "Dhis2::#{resource_name}"
    end
  end
end
