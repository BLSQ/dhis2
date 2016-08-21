module Dhis2
  class Base
    def initialize(raw_data)
      @raw_data = raw_data
      @id = raw_data["id"]
      @display_name = raw_data["displayName"]
    end

    def method_missing(m, *args, &block)
      return @raw_data[m.to_s] if @raw_data[m.to_s]
      super
    end

    class << self
      def find(id)
        response = Dhis2.get_resource("#{resource_name}/#{id}").get
        json_response = JSON.parse(response)
        new(json_response)
      end

      def list(options = {})
        options[:fields] = default_fields if default_fields && !options[:fields]
        response = Dhis2.get_resource(resource_name, options).get
        json_response = JSON.parse(response)
        PaginatedArray.new(
          json_response[resource_name].map { |raw_org_unit| new(raw_org_unit) },
          json_response["pager"]
        )
      end

      def resource_name
        simple_name = name.split("::").last
        simple_name[0].downcase + simple_name[1..-1] + "s"
      end

      def default_fields
        nil
      end
    end
  end
end
