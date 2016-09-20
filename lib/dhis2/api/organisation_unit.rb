module Dhis2
  module Api
    class OrganisationUnit < Base
      def initialize(client, params)
        super
        self.parent_id    = params["parent"]["id"] if params["parent"]
        self.children_ids = params["children"] ? params["children"].map { |raw| raw["id"] } : []
      end

      class << self
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
            if options[:include_descendants] || options[:include_children]
              json_response = client.get(resource_name, format_query_parameters(options))
              resource_key  = client.class.underscore(resource_name)
              PaginatedArray.new(
                json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
                json_response["pager"]
              )
            else
              new(client, json_response)
            end
          else
            response = client.get("#{resource_name}/#{id}")
            new(client, response)
          end
        end

        def last_level_descendants(client, id)
          levels     = client.organisation_unit_levels.list(fields: :all)
          last_level = levels.map(&:level).sort.last

          client.organisation_units.find(id, include_descendants: true).select do |ou|
            ou.level == last_level
          end
        end
      end
    end
  end
end
