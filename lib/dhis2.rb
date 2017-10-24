# frozen_string_literal: true

require "rest-client"
require "json"
require "ostruct"
require "uri"
require "delegate"
require "cgi"
require "dry-validation"

require_relative "dhis2/version"
require_relative "dhis2/case"
require_relative "dhis2/error"
require_relative "dhis2/configuration"
require_relative "dhis2/collection_wrapper"
require_relative "dhis2/pager"
require_relative "dhis2/paginated_array"
require_relative "dhis2/client"

require_relative "dhis2/api/base"
require_relative "dhis2/api/import_summary"
require_relative "dhis2/api/constants"
require_relative "dhis2/api/creatable"
require_relative "dhis2/api/deletable"
require_relative "dhis2/api/listable"
require_relative "dhis2/api/findable"
require_relative "dhis2/api/updatable"
require_relative "dhis2/api/query_parameters_formatter"

require_relative "dhis2/api/shared/analytic"

require_relative "dhis2/api/version224/index"
require_relative "dhis2/api/version225/index"


module Dhis2
  class << self
    def play(debug = false)
      Dhis2::Client.new(config.play_params(debug))
    end

    def client
      @client ||= Dhis2::Client.new(config.client_params)
    end

    def configure
      yield config
    end

    def config
      @configuration ||= Dhis2::Configuration.new
    end
  end
end
