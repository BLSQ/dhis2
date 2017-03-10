# frozen_string_literal: true
module Dhis2
  module Api
    class Event < Base
      class << self
        def create(client, tuples)
          body = { events: tuples }
          response = client.post(resource_name, body)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end
