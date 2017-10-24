# frozen_string_literal: true

module Dhis2
  module Api
    module Version225
      class ReportTable < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version225::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
        end

        private

        def instance_update_success?(response)
          # response is empty so...
          true
        end

        def self.created_instance_id(response)
          nil
        end

        def self.instance_creation_success?(response)
          response["status"] == "OK"
        end
      end
    end
  end
end