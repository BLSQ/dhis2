# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class OrganisationUnitGroup < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
        end

        def organisation_unit_ids
          organisation_units.map do |organisation_unit|
            organisation_unit["id"]
          end
        end

        def group_set_ids
          [organisation_unit_group_set, group_sets].flatten.compact.map do |group_set|
            group_set["id"]
          end
        end
      end
    end
  end
end