# frozen_string_literal: true

module Dhis2
  module Api
    class ImportSummary
      def initialize(hash)
        @hash = hash
      end

      def creation_success?
        base_success? && import_count["imported"] == 1
      end

      def update_success?
        base_success? && import_count["updated"] == 1
      end

      private

      attr_reader :hash

      def import_count
        hash["import_count"]
      end

      def base_success?
        %w(ImportSummary ImportTypeSummary).include?(hash["response_type"]) &&
          hash["status"] == "SUCCESS" &&
          import_count
      end
    end
  end
end
