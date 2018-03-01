# frozen_string_literal: true

module Dhis2
  module Api
    class ImportSummary
      def initialize(hash)
        @hash = hash
      end

      def reference
        hash["reference"]
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
        import_count["imported"]
      end

      def updated_count
        import_count["updated"]
      end

      def ignored_count
        import_count["ignored"]
      end

      def raw_status
        hash
      end

      private

      attr_reader :hash

      def only_updates_and_imports?
        ignored_count == 0 && (updated_count > 0 || imported_count > 0)
      end

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