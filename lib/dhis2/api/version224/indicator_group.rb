# frozen_string_literal: true

module Dhis2
  module Api
    module Version224
      class IndicatorGroup < ::Dhis2::Api::Base
        include ::Dhis2::Api::Listable
        include ::Dhis2::Api::Findable
        include ::Dhis2::Api::Updatable
        include ::Dhis2::Api::Deletable
      end
    end
  end
end