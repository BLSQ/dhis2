# frozen_string_literal: true

module Dhis2
  class QueryParametersFormatter
    def initialize(options:, query_parameters:)
      @options = options
      @query_parameters = query_parameters
    end

    def call
      # byebug
      # RestClient::ParamsArray.new(formatted_options)
      formatted_options.to_h
    end

    private

    attr_reader :options, :query_parameters

    def formatted_options
      [].tap do |params|
        query_parameters.each do |param|
          Array(options[param]).each do |value|
            params.push([::Dhis2::Case.camelize(param.to_s, false), value])
          end
        end
        params.push([:fields, format_fields(options[:fields])]) if options[:fields]
        params.concat(format_filter(options[:filter]))          if options[:filter]
      end
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
end
