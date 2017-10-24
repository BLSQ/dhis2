# frozen_string_literal: true

module Dhis2
  module Api
    module Findable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def find(client, id)
          raise "Missing id" if id.nil?

          if id.is_a? Array
            list(client, filter: "id:in:[#{id.join(',')}]", fields: :all, page_size: id.size)
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
      end
    end
  end
end