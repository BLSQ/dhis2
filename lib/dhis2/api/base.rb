module Dhis2
  module Api
    class Base < OpenStruct
      class << self
        def inherited(base)
          Dhis2::Client.register_resource(base)
        end

        def find(client, id, options = {})
          raise "Missing id" if id.nil?

          if id.class == Array
            list(client, filter: "id:in:[#{id.join(',')}]", fields: :all, page_size: id.size)
          elsif options.any?
            params = []
            options.each do |name, value|
              params << [name, value]
            end
            params        = client.class.deep_change_case(params, :camelize)
            json_response = client.get("#{resource_name}/#{id}", RestClient::ParamsArray.new(params))
            new(client, json_response)
          else
            response = client.get("#{resource_name}/#{id}")
            new(client, response)
          end
        end

        def find_by(client, clauses)
          filter = []
          clauses.each do |field, value|
            filter << "#{field}:eq:#{value}"
          end
          list(client, fields: :all, filter: filter).first
        end

        def list(client, options = {})
          json_response = client.get(resource_name, format_query_parameters(options))
          resource_key  = client.class.underscore(resource_name)
          PaginatedArray.new(
            json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
            json_response["pager"]
          )
        end

        def resource_name
          simple_name = name.split("::").last
          simple_name[0].downcase + simple_name[1..-1] + "s"
        end

        def format_query_parameters(options)
          params = []
          params.push([:page, options[:page]])                    if options[:page]
          params.push([:pageSize, options[:page_size]])           if options[:page_size]
          params.push([:fields, format_fields(options[:fields])]) if options[:fields]
          params.concat(format_filter(options[:filter]))          if options[:filter]

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

      def initialize(client, raw_data)
        raw_data["display_name"] ||= raw_data["name"]  # for backward compatbility with v2.19
        super(raw_data)
        self.client = client
      end

      def update_attributes(attributes)
        client.patch("#{self.class.resource_name}/#{id}", attributes)
        attributes.each do |key, value|
          self[key] = value
        end
        self
      end

      def add_relation(relation, relation_id)
        client.post("#{self.class.resource_name}/#{id}/#{relation}/#{relation_id}",{})
        self
      end

      def remove_relation(relation, relation_id)
        client.delete("#{self.class.resource_name}/#{id}/#{relation}/#{relation_id}",{})
        self
      end

      def delete
        client.delete("#{self.class.resource_name}/#{id}")
        true
      end

      def ==(other)
        self.class == other.class && id == other.id
      end

      def update
        client.put("#{self.class.resource_name}/#{id}", self.to_h)
      end
    end
  end
end
