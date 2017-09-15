# frozen_string_literal: true

module Dhis2
  class Client
    def self.register_resource(resource_class)
      class_name  = resource_class.name.split("::").last
      method_name = underscore(class_name) + "s"
      define_method(method_name) do
        CollectionWrapper.new(resource_class, self)
      end
    end
    SUPPORTER_CASE_CHANGES = %i[underscore camelize].freeze

    def self.deep_change_case(hash, type)
      raise "unsupported case changes #{type} vs #{SUPPORTER_CASE_CHANGES}" unless SUPPORTER_CASE_CHANGES.include?(type)
      case hash
      when Array
        hash.map { |v| deep_change_case(v, type) }
      when Hash
        new_hash = {}
        hash.each do |k, v|
          new_key = type == :underscore ? underscore(k.to_s) : camelize(k.to_s, false)
          new_hash[new_key] = deep_change_case(v, type)
        end
        new_hash
      else
        hash
      end
    end

    def self.camelize(string, uppercase_first_letter = true)
      string = if uppercase_first_letter
                 string.sub(/^[a-z\d]*/) { $&.capitalize }
               else
                 string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
               end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }.gsub("/", "::")
    end

    def self.underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, "/")
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def initialize(options)
      if options.is_a?(String)
        @base_url = options
      else
        raise "Missing :url attribute"      unless options[:url]
        raise "Missing :user attribute"     unless options[:user]
        raise "Missing :password attribute" unless options[:password]
        url          = URI.parse(options[:url])
        url.user     = CGI.escape(options[:user])
        url.password = CGI.escape(options[:password])
        @base_url    = url.to_s
        @verify_ssl = options[:no_ssl_verification] ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
        @timeout = options[:timeout] ? options[:timeout].to_i : 120
        @debug = options[:debug] && options[:debug] == true 
      end
    end

    def post(path, payload = nil, query_params = {})
      execute(:post, uri(path), headers, query_params, payload)
    end

    def get(path, query_params = {})
      execute(:get, uri(path), headers, query_params)
    end

    def delete(path, query_params = {})
      execute(:delete, uri(path), headers, query_params)
    end

    def put(path, payload, query_params = {})
      execute(:put, uri(path), headers, query_params, payload)
    end

    def patch(path, payload, query_params = {})
      execute(:patch, uri(path), headers, query_params, payload)
    end

    private

    def execute(method, url, headers, query_params = {}, payload = nil)
      query = {
        method:     method,
        url:        url,
        headers:    { params: query_params }.merge(headers),
        payload:    payload ? self.class.deep_change_case(payload, :camelize).to_json : nil,
        verify_ssl: @verify_ssl,
        timeout:    @timeout
      }
      
      raw_response = RestClient::Request.execute(query)
      
      puts raw_response.request.url if @debug
      response     = raw_response.nil? || raw_response == "" ? {} : JSON.parse(raw_response)
      response     = self.class.deep_change_case(response, :underscore)

      if  response.class == Hash && response["import_type_summaries"] &&
          response["import_type_summaries"][0] &&
          response["import_type_summaries"][0]["import_conflicts"] &&
          !response["import_type_summaries"].first["import_conflicts"].empty?
        raise Dhis2::ImportError, response["import_type_summaries"].first["import_conflicts"].first["value"].inspect
      end
      response
    end

    def uri(path)
      File.join(@base_url, "api", path)
    end

    def headers
      {
        content_type: :json,
        accept:       :json
      }
    end
  end
end
