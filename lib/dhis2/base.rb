module Dhis2
  class Base < OpenStruct
    class << self
      def find(id)
        if id.class == Array
          list(filter: "id:in:[#{id.join(',')}]", fields: :all, page_size: id.size)
        else
          response = Dhis2.client.get("#{resource_name}/#{id}")
          new(response)
        end
      end

      def find_by(clauses)
        filter = []
        clauses.each do |field, value|
          filter << "#{field}:eq:#{value}"
        end
        list(fields: :all, filter: filter).first
      end

      def list(options = {})
        json_response = Dhis2.client.get(resource_name, format_query_parameters(options))
        PaginatedArray.new(
          json_response[resource_name].map { |raw_resource| new(raw_resource) },
          json_response["pager"]
        )
      end

      def resource_name
        simple_name = name.split("::").last
        simple_name[0].downcase + simple_name[1..-1] + "s"
      end

      def format_query_parameters(options)
        params = []
        params.push([:page, options[:page]])                   if options[:page]
        params.push([:pageSize, options[:page_size]])          if options[:page_size]
        params.push([:fields, format_fields(options[:field])]) if options[:fields]
        params.concat(format_filter(options[:filter]))         if options[:filter]
        RestClient::ParamsArray.new(params)
      end

      def format_fields(fields)
        if fields.respond_to?(:join)
          fields.join(",")
        elsif fields == :all
          ":all"
        else
          fields
        end
      end

      def format_filter(filter)
        if filter.respond_to?(:map)
          filter.map do |subfilter|
            [:filter, subfilter]
          end
        else
          [[:filter, filter]]
        end
      end
    end

    def initialize(raw_data)
      super(raw_data)
      self.display_name = raw_data["displayName"]
    end

    def delete
      puts "#{self.class.resource_name}/#{id}"
      Dhis2.client.delete("#{self.class.resource_name}/#{id}")
    end

    def ==(other)
      self.class == other.class && id == other.id
    end
  end
end
