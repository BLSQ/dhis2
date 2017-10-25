# frozen_string_literal: true

module Dhis2
  module Api
    module Version226
      class DataValue < ::Dhis2::Api::Base
        def self.find(client, period:, organisation_unit:, data_element:)
          client.get(resource_name, pe: period,
                                    ou: organisation_unit,
                                    de: data_element).first
        end
      end
    end
  end
end
