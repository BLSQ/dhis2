module Dhis2
  class CollectionWrapper
    def initialize(klass, client)
      @klass  = klass
      @client = client
    end

    def method_missing(method_name, *args, &block)
      args = args.unshift(@client)
      @klass.__send__(method_name, *args, &block)
    end
  end
end
