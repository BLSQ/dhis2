# frozen_string_literal: true

module Dhis2
  class Configuration
    attr_accessor :url, :user, :password, :debug

    def client_params
      if user.nil? && password.nil?
        url
      else
        {
          url:      url,
          user:     user,
          password: password,
          debug:    debug
        }
      end
    end

    def play_params(with_debug, path)
      {
        url:      "https://play.dhis2.org/#{path}/",
        user:     "admin",
        password: "district",
        debug:    with_debug
      }
    end
  end
end
