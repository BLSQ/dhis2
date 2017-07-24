# frozen_string_literal: true

require "rest-client"
require "json"
require "ostruct"
require "uri"
require "delegate"
require "cgi"

require_relative "dhis2/version"
require_relative "dhis2/configuration"
require_relative "dhis2/collection_wrapper"
require_relative "dhis2/pager"
require_relative "dhis2/paginated_array"
require_relative "dhis2/import_error"
require_relative "dhis2/status"
require_relative "dhis2/client"

require_relative "dhis2/api/base"
require_relative "dhis2/api/category_combo"
require_relative "dhis2/api/category_option_combo"
require_relative "dhis2/api/organisation_unit"
require_relative "dhis2/api/data_element"
require_relative "dhis2/api/data_element_group"
require_relative "dhis2/api/data_set"
require_relative "dhis2/api/data_value_set"
require_relative "dhis2/api/data_value"
require_relative "dhis2/api/organisation_unit_level"
require_relative "dhis2/api/indicator"
require_relative "dhis2/api/analytic"
require_relative "dhis2/api/organisation_unit_group"
require_relative "dhis2/api/organisation_unit_group_set"
require_relative "dhis2/api/system_info"
require_relative "dhis2/api/attribute"
require_relative "dhis2/api/user"
require_relative "dhis2/api/event"
require_relative "dhis2/api/program"
require_relative "dhis2/api/report_table"
require_relative "dhis2/api/report"

module Dhis2
  class << self
    def client
      if @client.nil?
        @client ||= if config.user.nil? && config.password.nil?
                      Dhis2::Client.new(config.url)
                    else
                      Dhis2::Client.new(url:      config.url,
                                        user:     config.user,
                                        password: config.password)
                    end
      else
        @client
      end
    end

    def configure
      yield config
    end

    def config
      @configuration ||= Dhis2::Configuration.new
    end
  end
end
