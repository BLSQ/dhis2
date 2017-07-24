# frozen_string_literal: true

module Dhis2
  class PaginatedArray < DelegateClass(Array)
    attr_reader :pager

    def initialize(array, raw_pager = nil)
      super(array)
      @pager = Pager.new(raw_pager) if raw_pager
    end
  end
end
