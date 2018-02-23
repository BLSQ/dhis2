# frozen_string_literal: true

module Dhis2
  module Api
    class EventCreationStatus
      def initialize(response)
        @response = response
      end

      def creation_success?
        base_success? && only_updates_and_imports?
      end

      def update_success?
        base_success? && only_updates_and_imports?
      end

      def bulk_success?
        base_success?
      end

      def imported_count
        response["imported"]
      end

      def updated_count
        response["updated"]
      end

      def ignored_count
        response["ignored"]
      end

      def import_summaries
        @import_summaries ||= response["import_summaries"].map do |hash|
          Dhis2::Api::ImportSummary.new(hash)
        end
      end

      private

      attr_reader :response

      def only_updates_and_imports?
        ignored_count == 0 && (updated_count > 0 || imported_count > 0)
      end

      def base_success?
        response["response_type"] == "ImportSummary" &&
          response["status"] == "SUCCESS"
      end
    end
  end
end