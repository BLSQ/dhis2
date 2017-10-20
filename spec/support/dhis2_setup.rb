# frozen_string_literal: true

def build_client(version)
  Dhis2::Client.new({
    url: "https://play.dhis2.org/demo",
    user: "admin",
    password: "district",
    debug: ENV["DEBUG"] == "true",
    version: version
  })
end