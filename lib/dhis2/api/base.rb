# frozen_string_literal: true

module Dhis2
  module Api
    class Base < OpenStruct
      class << self
        def inherited(base)
          Dhis2::Client.register_resource(base)
        end

        def find(client, id, options = {})
          raise "Missing id" if id.nil?

          if id.is_a? Array
            list(client, filter: "id:in:[#{id.join(',')}]", fields: :all, page_size: id.size)
          elsif options.any?
            params        = Dhis2::Utils.deep_change_case(options.to_a, :camelize)
            json_response = client.get("#{resource_name}/#{id}", RestClient::ParamsArray.new(params))
            new(client, json_response)
          else
            new(client, client.get("#{resource_name}/#{id}"))
          end
        end

        def find_by(client, clauses)
          list(
            client,
            fields: :all,
            filter: clauses.map { |field, value| "#{field}:eq:#{value}" }
          ).first
        end

        def list(client, options = {})
          json_response = client.get(resource_name, format_query_parameters(options))
          PaginatedArray.new(
            json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
            json_response["pager"]
          )
        end

        def resource_key
          Dhis2::Utils.underscore(resource_name)
        end

        def resource_name
          simple_name = name.split("::").last
          simple_name[0].downcase + simple_name[1..-1] + "s"
        end

        private

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

        def ensure_array(obj)
          obj.is_a?(Array) ? obj : [obj]
        end
      end

      def initialize(client, raw_data)
        raw_data["display_name"] ||= raw_data["name"] # for backward compatbility with v2.19
        super(raw_data)
        self.client = client
      end

      def update_attributes(attributes)
        client.patch("#{self.class.resource_name}/#{id}", attributes)
        attributes.each do |key, value|
          public_send("#{key}=", value)
        end
        self
      end

      def add_relation(relation, relation_id)
        client.post("#{self.class.resource_name}/#{id}/#{relation}/#{relation_id}", {})
        self
      end

      def remove_relation(relation, relation_id)
        client.delete("#{self.class.resource_name}/#{id}/#{relation}/#{relation_id}", {})
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
        client.put("#{self.class.resource_name}/#{id}", to_h.reject { |k, _| k == :client })
      end
    end
  end
end
