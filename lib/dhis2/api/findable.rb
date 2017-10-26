# frozen_string_literal: true

module Dhis2
  module Api
    module Findable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def find(client, id, fields: :all)
          raise Dhis2::PrimaryKeyMissingError if id.nil?

          if id.is_a? Array
            list(client, filter: "id:in:[#{id.join(',')}]", fields: fields, page_size: id.size)
          else
            new(client, client.get("#{resource_name}/#{id}"))
          end
        end

        def find_by(client, clauses, fields: :all)
          list(
            client,
            fields: fields,
            filter: clauses.map { |field, value| "#{field}:eq:#{value}" }
          ).first
        end
      end
    end
  end
end
