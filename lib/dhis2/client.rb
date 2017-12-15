# frozen_string_literal: true

module Dhis2
  class Client
    attr_reader :version

    def initialize(options)
      @base_url   = options.fetch(:url)
      @version    = options.fetch(:version)
      @verify_ssl = options.fetch(:verify_ssl, OpenSSL::SSL::VERIFY_PEER)
      @timeout    = options.fetch(:timeout, 120)
      @debug      = options.fetch(:debug, false)
    end

    def post(path, payload = nil, query_params = {})
      execute(:post, uri(path), query_params, payload)
    end

    def get(path, query_params = {})
      execute(:get, uri(path), query_params)
    end

    def delete(path, query_params = {})
      execute(:delete, uri(path), query_params)
    end

    def put(path, payload, query_params = {})
      execute(:put, uri(path), query_params, payload)
    end

    def patch(path, payload, query_params = {})
      execute(:patch, uri(path), query_params, payload)
    end

    def analytics
      @analytics ||= CollectionWrapper.new("Analytic", self)
    end

    def attributes
      @attributes ||= CollectionWrapper.new("Attribute", self)
    end

    def category_combos
      @category_combos ||= CollectionWrapper.new("CategoryCombo", self)
    end

    def category_option_combos
      @category_option_combos ||= CollectionWrapper.new("CategoryOptionCombo", self)
    end

    def data_elements
      @data_elements ||= CollectionWrapper.new("DataElement", self)
    end

    def data_element_groups
      @data_element_groups ||= CollectionWrapper.new("DataElementGroup", self)
    end

    def data_sets
      @data_sets ||= CollectionWrapper.new("DataSet", self)
    end

    def data_values
      @data_values ||= CollectionWrapper.new("DataValue", self)
    end

    def data_value_sets
      @data_value_sets ||= CollectionWrapper.new("DataValueSet", self)
    end

    def events
      @events ||= CollectionWrapper.new("Event", self)
    end

    def indicators
      @indicators ||= CollectionWrapper.new("Indicator", self)
    end

    def indicator_groups
      @indicator_groups ||= CollectionWrapper.new("IndicatorGroup", self)
    end

    def indicator_types
      @indicator_types ||= CollectionWrapper.new("IndicatorType", self)
    end

    def organisation_units
      @organisation_units ||= CollectionWrapper.new("OrganisationUnit", self)
    end

    def organisation_unit_groups
      @organisation_unit_groups ||= CollectionWrapper.new("OrganisationUnitGroup", self)
    end

    def organisation_unit_group_sets
      @organisation_unit_group_sets ||= CollectionWrapper.new("OrganisationUnitGroupSet", self)
    end

    def organisation_unit_levels
      @organisation_unit_levels ||= CollectionWrapper.new("OrganisationUnitLevel", self)
    end

    def programs
      @programs ||= CollectionWrapper.new("Program", self)
    end

    def reports
      @reports ||= CollectionWrapper.new("Report", self)
    end

    def report_tables
      @report_tables ||= CollectionWrapper.new("ReportTable", self)
    end

    def resource_tables
      @resource_tables ||= CollectionWrapper.new("ResourceTable", self)
    end

    def system_infos
      @system_infos ||= CollectionWrapper.new("SystemInfo", self)
    end

    def users
      @users ||= CollectionWrapper.new("User", self)
    end

    def can_connect?
      system_infos.get
      true
    rescue ::Dhis2::Error
      false
    rescue StandardError
      false
    end

    private

    def execute(method_name, url, query_params = {}, payload = nil)
      raw_response = RestClient::Request.execute(
        method:     method_name,
        url:        url,
        headers:    headers(method_name, query_params),
        payload:    payload ? Dhis2::Case.deep_change(payload, :camelize).to_json : nil,
        verify_ssl: @verify_ssl,
        timeout:    @timeout
      )
      response = [nil, ""].include?(raw_response) ? {} : JSON.parse(raw_response)
      log(raw_response.request, response)
      Dhis2::Case.deep_change(response, :underscore)
    rescue RestClient::Exception => e
      exception = ::Dhis2::RequestError.new(e.message)
      exception.response = e.response
      raise exception
    end

    def uri(path)
      File.join(@base_url, "api", path)
    end

    def headers(method_name, query_params)
      { params: query_params, accept: :json }.tap do |hash|
        hash[:content_type] = :json unless method_name == :get
      end
    end

    def log(request, response)
      puts [request.url, request.args[:payload], response].join("\t") if @debug
    end
  end
end
