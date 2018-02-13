# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class OrganisationUnit < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::BulkCreatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator
        include ::Dhis2::Api::Shared::OrganisationUnit

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:short_name).filled
          required(:opening_date).filled
        end
      end
    end
  end
end
