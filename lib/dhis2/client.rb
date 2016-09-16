module Dhis2
  class Client
    def initialize(base_url, user, password)
      url          = URI.parse(base_url)
      url.user     = CGI.escape(user)
      url.password = CGI.escape(password)
      @base_url    = url.to_s
    end

    def post(path, payload, query_params = {})
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

    private

    def execute(method, url, headers, query_params = {}, payload = nil)
      query = {
        method:  method,
        url:     url,
        headers: { params: query_params }.merge(headers),
        payload: payload ? payload.to_json : nil
      }

      raw_response = RestClient::Request.execute(query)
      response     = raw_response.nil? || raw_response == "" ? {} : JSON.parse(raw_response)

      if  response.class == Hash && response["importTypeSummaries"] &&
          response["importTypeSummaries"][0] &&
          response["importTypeSummaries"][0]["importConflicts"] &&
          !response["importTypeSummaries"].first["importConflicts"].empty?
        raise Dhis2::ImportError, response["importTypeSummaries"].first["importConflicts"].first["value"].inspect
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
