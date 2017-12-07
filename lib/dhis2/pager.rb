# frozen_string_literal: true

module Dhis2
  class Pager
    attr_reader :page, :page_count, :total, :next_page, :page_size

    def initialize(hash)
      @page       = hash["page"]
      @page_count = hash["page_count"]
      @total      = hash["total"]
      @next_page  = hash["next_page"]
      @page_size  = hash["page_size"]
    end

    def last_page?
      page * page_size >= total
    end
  end
end
