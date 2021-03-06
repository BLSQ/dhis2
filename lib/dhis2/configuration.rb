# frozen_string_literal: true

module Dhis2
  class Configuration
    ALLOWED_VERSIONS = %w(2.24 2.25 2.26 2.27 2.28).freeze

    attr_accessor :url, :user, :password, :debug, :no_ssl_verification, :timeout

    def client_params
      {
        url:        no_credentials? ? url : build_url,
        debug:      debug,
        version:    version,
        timeout:    timeout,
        verify_ssl: verify_ssl
      }
    end

    def play_params(with_debug, version)
      {
        url:     "https://admin:district@play.dhis2.org/#{version}/",
        debug:   with_debug,
        version: version
      }
    end

    def version=(version)
      raise Dhis2::InvalidVersionError, version.to_s unless ALLOWED_VERSIONS.include?(version)
      @version = version
    end

    private

    def verify_ssl
      if no_ssl_verification
        OpenSSL::SSL::VERIFY_NONE
      else
        OpenSSL::SSL::VERIFY_PEER
      end
    end

    def version
      @version || default_version
    end

    def default_version
      ALLOWED_VERSIONS.last
    end

    def no_credentials?
      user.nil? && password.nil?
    end

    def build_url
      URI.parse(url).tap do |url|
        url.user     = CGI.escape(user)
        url.password = CGI.escape(password)
      end.to_s
    end
  end
end
