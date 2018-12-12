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

    def post(path:, payload: nil, query_params: {}, raw: false, raw_input: false)
      execute(method_name: :post, url: uri(path), query_params: query_params, payload: payload, raw: raw, raw_input: raw_input)
    end

    def get(path:, query_params: {}, raw: false)
      execute(method_name: :get, url: uri(path), query_params: query_params, raw: raw)
    end

    def delete(path:, query_params: {}, raw: false)
      execute(method_name: :delete, url: uri(path), query_params: query_params, raw: raw)
    end

    def put(path:, payload:, query_params: {}, raw: false)
      execute(method_name: :put, url: uri(path), query_params: query_params, payload: payload, raw: raw)
    end

    def patch(path:, payload:, query_params: {}, raw: false)
      execute(method_name: :patch, url: uri(path), query_params: query_params, payload: payload, raw: raw)
    end

    def analytics
      @analytics ||= CollectionWrapper.new("Analytic", self)
    end

    def attributes
      @attributes ||= CollectionWrapper.new("Attribute", self)
    end

    def categories
      @categories ||= CollectionWrapper.new("Category", self)
    end

    def category_options
      @category_options ||= CollectionWrapper.new("CategoryOption", self)
    end

    def category_combos
      @category_combos ||= CollectionWrapper.new("CategoryCombo", self)
    end

    def category_option_combos
      @category_option_combos ||= CollectionWrapper.new("CategoryOptionCombo", self)
    end

    def complete_data_set_registrations
      @complete_data_set_registrations ||= CollectionWrapper.new("CompleteDataSetRegistration", self)
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
  
    def legend_sets
      @legend_sets ||= CollectionWrapper.new("LegendSet", self)
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

    def self.uri(base_url, path)
      File.join(base_url, API, path)
    end

    private

    EMPTY_RESPONSES = [nil, ""]
    API =  "api"
    TAB = "\t"

    def execute(method_name:, url:, query_params: {}, payload: nil, raw: false, raw_input: false)
      computed_payload = compute_payload(payload, raw_input)

      raw_response = RestClient::Request.execute(
        method:     method_name,
        url:        url,
        headers:    headers(method_name, query_params),
        payload:    computed_payload,
        verify_ssl: @verify_ssl,
        timeout:    @timeout
      )
      response = EMPTY_RESPONSES.include?(raw_response) ? {} : JSON.parse(raw_response)
      log(raw_response.request, response)
      if raw
        response
      else
        Dhis2::Case.deep_change(response, :underscore)
      end
    rescue RestClient::RequestFailed => e
      exception = ::Dhis2::RequestError.new(e.message)
      exception.response  = e.response  if e.respond_to?(:response)
      exception.http_code = e.http_code if e.respond_to?(:http_code)
      exception.http_body = e.http_body if e.respond_to?(:http_body)
      log(exception.response.request, exception.response)
      raise exception
    end

    def compute_payload(payload, raw_input)
      return nil unless payload
      return payload.to_json if raw_input
      Dhis2::Case.deep_change(payload, :camelize).to_json
    end

    def uri(path)
      self.class.uri(@base_url, path)
    end

    def headers(method_name, query_params)
      { params: query_params, accept: :json }.tap do |hash|
        hash[:content_type] = :json unless method_name == :get
      end
    end

    def log(request, response)
      puts [request.url, request.args[:payload].to_json, response.to_json].join(TAB) if @debug
    end
  end
end
