# frozen_string_literal: true

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
            params = options.map do |name, value|
              [Dhis2::Case.camelize(name.to_s, false), value]
            end
            params        = Dhis2::Case.deep_change(params, :camelize)
            json_response = client.get("#{resource_name}/#{id}", RestClient::ParamsArray.new(params))
            if options[:include_descendants] || options[:include_children]
              json_response = client.get(resource_name, format_query_parameters(options))
              resource_key  = Dhis2::Case.underscore(resource_name)
              PaginatedArray.new(
                json_response[resource_key].map { |raw_resource| new(client, raw_resource) },
                json_response["pager"]
              )
            else
              new(client, json_response)
            end
          else
            new(client, client.get("#{resource_name}/#{id}"))
          end
        end

        def create(client, orgunits)
          payload = {
            organisationUnits: ensure_array(orgunits).map do |orgunit|
              orgunit[:parent] = { id: orgunit[:parent_id] } if orgunit[:parent_id]
              orgunit[:id] = orgunit[:id] if orgunit[:id]
              orgunit
            end
          }

          response = client.post("metadata", payload)
          Dhis2::Status.new(response)
        end

        def last_level_descendants(client, id)
          last_level = client.organisation_unit_levels
                             .list(fields: :all)
                             .map(&:level)
                             .sort
                             .last

          client.organisation_units.find(id, include_descendants: true).select do |ou|
            ou.level == last_level
          end
        end
      end
    end
  end
end
