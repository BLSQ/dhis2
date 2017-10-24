# frozen_string_literal: true

module Dhis2
  module Api
    module Version226
      class OrganisationUnit < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Version226::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:short_name).filled
          required(:opening_date).filled
        end

        def parent_id
          parent ? parent["id"] : nil
        end

        def children_ids
          children ? children.map { |elt| elt["id"] } : []
        end
      end
    end
  end
end