# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class Program < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Creatable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
        include ::Dhis2::Api::Shared::SaveValidator

        Schema = Dry::Validation.Schema do
          required(:name).filled
          required(:short_name).filled
          required(:program_type).value(
            included_in?: ::Dhis2::Api::Version228::Constants.program_types
          )
        end
      end
    end
  end
end
