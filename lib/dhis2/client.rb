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

    @@cookie_jar = {}

    def execute(method_name, url, query_params = {}, payload = nil)
      

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      raw_response = RestClient::Request.execute(
        method:     method_name,
        url:        url,
        headers:    headers(method_name, query_params),
        payload:    payload ? Dhis2::Case.deep_change(payload, :camelize).to_json : nil,
        verify_ssl: @verify_ssl,
        timeout:    @timeout,
        cookies:    @@cookie_jar[@base_url]
      )
      finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      diff = finish - start # gets time is seconds as a float
      puts diff
      @@cookie_jar[@base_url] = raw_response.cookies
      
      response = [nil, ""].include?(raw_response) ? {} : JSON.parse(raw_response)
      
      log(raw_response.request, response, diff)
      Dhis2::Case.deep_change(response, :underscore).tap do |underscore_response|
        if any_conflict?(underscore_response)
          raise Dhis2::ImportError, extract_conflict_message(underscore_response)
        end
      end
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

    def log(request, response,diff)
      puts [request.url, request.args[:payload], response, "in #{diff}"].join("\t") if @debug
    end
  end
end
