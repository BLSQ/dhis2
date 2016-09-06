require "dhis2/version"
require "rest-client"
require "json"
require "organisation_unit"
require "data_element"
require "data_set"
require "category_combo"
require "organisation_unit_level"
require "status"
require "paginated_array"

module Dhis2
  class << self
    attr_reader :url

    def connect(options)
      raise "Missing #{url}" unless options[:url]
      raise "Missing #{user}" unless options[:user]
      raise "Missing #{password}" unless options[:password]

      @url = options[:url]
      @user = options[:user]
      @password = options[:password]
    end

    def get_resource(name, options = {})
      arguments = []
      if options[:fields]
        arguments << "fields=" + options[:fields].join(",") if options[:fields].respond_to?(:join)
        arguments << "fields=:#{options[:fields]}" if options[:fields].class == Symbol
      end
      arguments << "filter=" + options[:filter] if options[:filter]
      arguments << "pageSize=#{options[:page_size]}" if options[:page_size]
      arguments << "page=#{options[:page]}" if options[:page]

      path = "#{name}?#{arguments.join('&')}"
      resource[path]
    end

    def resource
      @resource ||= RestClient::Resource.new("#{@url}/api", headers: { accept: "application/json" }, user: @user, password: @password)
    end

    def camelize(str)
      str.gsub(/\_([a-z])/, "")
    end
  end
end
