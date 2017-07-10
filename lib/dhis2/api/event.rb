# frozen_string_literal: true

module Dhis2
  module Api
    class Event < Base
      class << self
        def create(client, tuples)
          begin
            body = { resource_name.to_sym => tuples }
            response = client.post(resource_name, body)
          rescue RestClient::Conflict => e
            response = Dhis2::Client.deep_change_case(JSON.parse(e.response.body), :underscore)
          end
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
