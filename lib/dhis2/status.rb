module Dhis2
  class Status
    attr_reader :raw_status

    def initialize(raw_status)
      @raw_status = raw_status
    end

    def success?
      return @raw_status["importTypeSummaries"].all? { |summary| summary["status"] == "SUCCESS" } if @raw_status["importTypeSummaries"]
      @raw_status["status"] == "SUCCESS"
    end

    def import_count
      @raw_status["importCount"]
    end

    def total_imported
      total = 0
      import_count.each do |_, count|
        total += count
      end
      total
    end

    def last_imported_ids
      @raw_status["importTypeSummaries"].map { |summary| summary["lastImported"] }
    end
  end
end
