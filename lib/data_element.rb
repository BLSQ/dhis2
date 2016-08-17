require "base"

module Dhis2
  class DataElement < Base
    attr_reader :id, :display_name

    def initialize(params)
      super(params)
      @id = params["id"]
      @display_name = params["displayName"]
    end
  end
end
