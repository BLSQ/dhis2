module Dhis2
  class Base
    def initialize(raw_data)
      @raw_data = raw_data
    end

    def method_missing(m, *args, &block)
      return @raw_data[m.to_s] if @raw_data[m.to_s]
      super
    end
  end
end
