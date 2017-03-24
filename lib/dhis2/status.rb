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
      ["SUCCESS", "OK"].include?(@raw_status["status"])
    end

    def total_imported
      total = 0
      if @raw_status["import_count"]
        @raw_status["import_count"].each do |_, count|
          total += count
        end
      elsif @raw_status["type_reports"]
        total += @raw_status["type_reports"].first["stats"]["total"]
      end
      total
    end

    def last_imported_ids
      return [] unless @raw_status["import_type_summaries"]
      @raw_status["import_type_summaries"].map { |summary| summary["last_imported"] }
    end

    def import_summaries
      return [] unless @raw_status["response"]["import_summaries"]
      @raw_status["response"]["import_summaries"].map {|it| OpenStruct.new(it) }
    end
  end
end
