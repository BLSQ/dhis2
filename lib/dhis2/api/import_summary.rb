# frozen_string_literal: true

module Dhis2
  module Api
    class ImportSummary
      def initialize(hash)
        @hash = hash
      end

      def creation_success?
        base_success? && only_updates_and_imports?
      end

      def update_success?
        base_success? && only_updates_and_imports?
      end

      private

      attr_reader :hash

      def only_updates_and_imports?
        import_count["ignored"] == 0 &&
          (import_count["updated"] > 0 || import_count["imported"] > 0)
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
