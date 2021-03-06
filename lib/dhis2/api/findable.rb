# frozen_string_literal: true

module Dhis2
  module Api
    module Findable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # https://docs.dhis2.org/2.25/en/developer/html/webapi_metadata_object_filter.html
        def find(client, id, fields: :all, raw: false)
          raise Dhis2::PrimaryKeyMissingError if id.nil?

          if id.is_a? Array
            list(client, { filter: "id:in:[#{id.join(',')}]", fields: fields, page_size: id.size }, raw)
          else
            if raw
              client.get(path: "#{resource_name}/#{id}", raw: true)
            else
              new(client, client.get(path: "#{resource_name}/#{id}"))
            end
          end
        end

        # batch size is to prevent from sending get requests with uri too long
        # max uri length is around 2000 chars, a dhis id is around 11 chars, 100 is a safe default
        def find_paginated(client, ids, fields: :all, batch_size: 100, raw: false)
          Enumerator.new do |yielder|
            loop do
              ids.each_slice(batch_size) do |array|
                find(client, array, fields: fields, raw: raw).map do |item|
                  yielder << item
                end
              end
              raise StopIteration
            end
          end
        end

        def find_by(client, clauses, fields: :all, raw: false)
          list(
            client,
            fields: fields,
            filter: clauses.map { |field, value| "#{field}:eq:#{value}" },
            raw: raw
          ).first
        end
      end
    end
  end
end
