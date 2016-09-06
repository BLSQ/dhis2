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

    def ==(other)
      self.class == other.class && id == other.id
    end

    class << self
      def find(id)
        if id.class == Array
          list(filter: "id:in:[#{id.join(',')}]", fields: :all, page_size: 10000)
        else
          response = Dhis2.get_resource("#{resource_name}/#{id}").get
          json_response = JSON.parse(response)
          new(json_response)
        end
      end

      def find_by(clauses)
        filter = []
        clauses.each do |field, value|
          filter << "#{field}:eq:#{value}"
        end
        list(fields: :all, filter: filter.join("&")).first
      end

      def list(options = {})
        options[:fields] = default_fields if default_fields && !options[:fields]
        response = Dhis2.get_resource(resource_name, options).get
        json_response = JSON.parse(response)
        PaginatedArray.new(
          json_response[resource_name].map { |raw_org_unit| new(raw_org_unit) },
          json_response["pager"])
      end

      def resource_name
        simple_name = name.split("::").last
        simple_name[0].downcase + simple_name[1..-1] + "s"
      end

      def default_fields
        nil
      end
    end

    def delete
      Dhis2.resource["#{self.class.resource_name}/#{@id}"]
           .delete {|response, request, result| response.code == 204 }
    end
  end
end
