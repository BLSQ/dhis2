module Dhis2
  class Status
    attr_reader :raw_status

    def initialize(raw_status)
      @raw_status = raw_status
    end

    def success?
      if @raw_status["import_type_summaries"]
        return @raw_status["import_type_summaries"].all? do |summary|
          summary["status"] == "SUCCESS"
        end
      end
      @raw_status["status"] == "SUCCESS"
    end

    def import_count
      @raw_status["import_count"]
    end

    def total_imported
      total = 0
      import_count.each do |_, count|
        total += count
      end
      total
    end

    def last_imported_ids
      @raw_status["import_type_summaries"].map { |summary| summary["last_imported"] }
    end
  end
end
