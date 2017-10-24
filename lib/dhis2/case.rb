# frozen_string_literal: true

module Dhis2
  module Case
    SUPPORTER_CASE_CHANGES = %i(underscore camelize).freeze

    def self.deep_change(obj, type)
      raise CaseError.new(deep_change_error(type)) unless SUPPORTER_CASE_CHANGES.include?(type)
      case obj
      when Array then obj.map { |v| deep_change(v, type) }
      when Hash
        obj.each_with_object({}) do |(k, v), new_hash|
          new_key = type == :underscore ? underscore(k.to_s) : camelize(k.to_s, false)
          new_hash[new_key] = deep_change(v, type)
        end
      else obj
      end
    end

    def self.camelize(string, uppercase_first_letter = true)
      string = if uppercase_first_letter
                 string.sub(/^[a-z\d]*/) { $&.capitalize }
               else
                 string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
               end
      string
        .gsub(/(?:_|(\/))([a-z\d]*)/) do
          "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
        end
        .gsub("/", "::")
    end

    def self.underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      camel_cased_word.to_s.gsub(/::/, "/")
                      .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .tr("-", "_")
                      .downcase
    end

    def deep_change_error(type)
      "unsupported case changes #{type} vs #{SUPPORTER_CASE_CHANGES}"
    end
  end
end
