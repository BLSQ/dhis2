# frozen_string_literal: true

module Dhis2
  class Status
    attr_reader :raw_status

    def initialize(raw_status)
      @raw_status = raw_status
    end

    def success?
      if raw_status["import_type_summaries"]
        return raw_status["import_type_summaries"].all? do |summary|
          summary["status"] == "SUCCESS"
        end
      end
      %w(SUCCESS OK).include?(raw_status["status"])
    end

    def total_imported
      if raw_status["import_count"]
        raw_status["import_count"].inject(0) do |total, (_, count)|
          total + count
        end
      elsif raw_status["type_reports"]
        raw_status["type_reports"].first["stats"]["total"]
      end
    end

    def last_imported_ids
      return [] unless raw_status["import_type_summaries"]
      raw_status["import_type_summaries"].map { |summary| summary["last_imported"] }
    end

    def import_summaries
      return [] unless raw_status["response"]["import_summaries"]
      raw_status["response"]["import_summaries"].map { |it| OpenStruct.new(it) }
    end
  end
end
