# frozen_string_literal: true

module Dhis2
  class Client
    def self.register_resource(resource_class)
      define_method(resource_class.resource_key) do
        CollectionWrapper.new(resource_class, self)
      end
    end

    def initialize(options)
      if options.is_a?(String)
        @base_url = options
        set_connection_options
      else
        raise "Missing :url attribute"      unless options[:url]
        raise "Missing :user attribute"     unless options[:user]
        raise "Missing :password attribute" unless options[:password]
        url          = URI.parse(options[:url])
        url.user     = CGI.escape(options[:user])
        url.password = CGI.escape(options[:password])
        @base_url    = url.to_s
        set_connection_options(options)
      end
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

    private

    def execute(method_name, url, query_params = {}, payload = nil)
      query = {
        method:     method_name,
        url:        url,
        headers:    { params: query_params }.merge(headers(method_name)),
        payload:    payload ? Dhis2::Utils.deep_change_case(payload, :camelize).to_json : nil,
        verify_ssl: @verify_ssl,
        timeout:    @timeout
      }

      raw_response = RestClient::Request.execute(query)

      response = raw_response.nil? || raw_response == "" ? {} : JSON.parse(raw_response)

      puts [raw_response.request.url, query[:payload], response].join("\t") if @debug

      response = Dhis2::Utils.deep_change_case(response, :underscore)

      if any_conflict?(response)
        raise Dhis2::ImportError, response["import_type_summaries"].first["import_conflicts"].first["value"].inspect
      end
      response
    end

    def uri(path)
      File.join(@base_url, "api", path)
    end

    def headers(method_name)
      { accept: :json }.tap do |hash|
        hash[:content_type] = :json unless method_name == :get
      end
    end

    def any_conflict?(response)
      response.class == Hash && response["import_type_summaries"] &&
        response["import_type_summaries"][0] &&
        response["import_type_summaries"][0]["import_conflicts"] &&
        !response["import_type_summaries"].first["import_conflicts"].empty?
    end

    def set_connection_options(options = {})
      @verify_ssl = options[:no_ssl_verification] ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
      @timeout    = options[:timeout] ? options[:timeout].to_i : 120
      @debug      = options.fetch(:debug, true)
    end
  end
end
