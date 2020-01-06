# frozen_string_literal: true

module Dhis2
  module Api
    module Version228
      class ProgramIndicator < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
      end
    end
  end
end
