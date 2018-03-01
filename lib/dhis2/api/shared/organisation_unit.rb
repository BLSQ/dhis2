# frozen_string_literal: true

module Dhis2
  module Api
    module Shared
      module OrganisationUnit
        def parent_id
          parent ? parent["id"] : nil
        end

        def children_ids
          children ? children.map { |elt| elt["id"] } : []
        end
      end
    end
  end
end
