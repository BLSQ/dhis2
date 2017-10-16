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
        connection_options
      else
        raise "Missing :url attribute"      unless options[:url]
        raise "Missing :user attribute"     unless options[:user]
        raise "Missing :password attribute" unless options[:password]
        url          = URI.parse(options[:url])
        url.user     = CGI.escape(options[:user])
        url.password = CGI.escape(options[:password])
        @base_url    = url.to_s
        connection_options(options)
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
      Dhis2::Case.deep_change(response, :underscore).tap do |underscore_response|
        if any_conflict?(underscore_response)
          raise Dhis2::ImportError, extract_conflict_message(underscore_response)
        end
      end
    rescue => e
      raise Dhis2::ImportError, "Dhis2Error : was calling #{[method_name, safe_url(url), query_params, Dhis2::Case.deep_change(payload, :camelize)]} but got #{e.message} #{e.response.body}"
    end

    def safe_url(url)
      uri = URI.parse(url)
      uri.password = 'REDACTED'
      uri.to_s
    end

    def uri(path)
      File.join(@base_url, "api", path)
    end

    def headers(method_name, query_params)
      { params: query_params, accept: :json }.tap do |hash|
        hash[:content_type] = :json unless method_name == :get
      end
    end

    def any_conflict?(hash)
      hash.class == Hash && hash["import_type_summaries"] &&
        hash["import_type_summaries"][0] &&
        hash["import_type_summaries"][0]["import_conflicts"] &&
        !hash["import_type_summaries"].first["import_conflicts"].empty?
    end

    def extract_conflict_message(hash)
      hash["import_type_summaries"].first["import_conflicts"].first["value"].inspect
    end

    def connection_options(options = {})
      @verify_ssl = if options[:no_ssl_verification]
                      OpenSSL::SSL::VERIFY_NONE
                    else
                      OpenSSL::SSL::VERIFY_PEER
                    end
      @timeout    = options[:timeout] ? options[:timeout].to_i : 120
      @debug      = options.fetch(:debug, true)
    end

    def log(request, response)
      puts [safe_url(request.url), request.args[:payload], response].join("\t") if @debug
    end
  end
end
