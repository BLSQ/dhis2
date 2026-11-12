# frozen_string_literal: true

module Dhis2
  class CollectionWrapper
    def initialize(klass, client)
      @klass  = klass
      @client = client
    end

    def method_missing(method_name, *args, &block)
      @klass.__send__(method_name, @client, *args, &block)
    end
    # keep keyword arguments as keywords when delegating (ruby 3)
    ruby2_keywords(:method_missing) if respond_to?(:ruby2_keywords, true)

    def respond_to_missing?(method_name, include_private = false)
      @klass.respond_to?(method_name, include_private) || super
    end
  end
end
