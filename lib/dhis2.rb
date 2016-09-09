require "rest-client"
require "json"
require "ostruct"
require "uri"
require "delegate"

require "dhis2/pager"
require "dhis2/version"
require "dhis2/base"
require "dhis2/category_combo"
require "dhis2/organisation_unit"
require "dhis2/data_element"
require "dhis2/data_element_group"
require "dhis2/data_set"
require "dhis2/data_value_sets"
require "dhis2/organisation_unit_level"
require "dhis2/status"
require "dhis2/paginated_array"
require "dhis2/client"
require "dhis2/import_error"

module Dhis2
  class << self
    attr_reader :url

    def connect(options)
      raise "Missing #{url}" unless options[:url]
      raise "Missing #{user}" unless options[:user]
      raise "Missing #{password}" unless options[:password]

      @url      = options[:url]
      @user     = options[:user]
      @password = options[:password]
    end

    def client
      @client ||= Dhis2::Client.new(@url, @user, @password)
    end

    def camelize(str)
      str.gsub(/\_([a-z])/, "")
    end
  end
end
