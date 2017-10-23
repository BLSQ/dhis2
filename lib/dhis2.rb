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
require_relative "dhis2/api/constants"
require_relative "dhis2/api/creatable"
require_relative "dhis2/api/deletable"
require_relative "dhis2/api/listable"
require_relative "dhis2/api/findable"
require_relative "dhis2/api/updatable"
require_relative "dhis2/api/query_parameters_formatter"

require_relative "dhis2/api/shared/analytic"

require_relative "dhis2/api/version224/save_validator"
require_relative "dhis2/api/version224/constants"

require_relative "dhis2/api/version224/analytic"
require_relative "dhis2/api/version224/attribute"
require_relative "dhis2/api/version224/category_combo"
require_relative "dhis2/api/version224/category_option_combo"
require_relative "dhis2/api/version224/data_element"
require_relative "dhis2/api/version224/data_element_group"
require_relative "dhis2/api/version224/data_set"
require_relative "dhis2/api/version224/data_value"
require_relative "dhis2/api/version224/data_value_set"
require_relative "dhis2/api/version224/event"
require_relative "dhis2/api/version224/indicator"
require_relative "dhis2/api/version224/indicator_group"
require_relative "dhis2/api/version224/indicator_type"
require_relative "dhis2/api/version224/organisation_unit"
require_relative "dhis2/api/version224/organisation_unit_group"
require_relative "dhis2/api/version224/organisation_unit_group_set"
require_relative "dhis2/api/version224/organisation_unit_level"
require_relative "dhis2/api/version224/program"
require_relative "dhis2/api/version224/report_table"
require_relative "dhis2/api/version224/resource_table"
require_relative "dhis2/api/version224/report"
require_relative "dhis2/api/version224/system_info"
require_relative "dhis2/api/version224/user"

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
