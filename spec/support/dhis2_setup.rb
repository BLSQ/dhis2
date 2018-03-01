# frozen_string_literal: true

def build_client(version)
  Dhis2::Client.new(url:     "https://admin:district@play.dhis2.org/demo",
                    debug:   ENV["DEBUG"] == "true",
                    version: version)
end
