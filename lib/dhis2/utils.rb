# frozen_string_literal: true

module Dhis2
  module Utils
    SUPPORTER_CASE_CHANGES = %i(underscore camelize).freeze

    def self.deep_change_case(hash, type)
      raise "unsupported case changes #{type} vs #{SUPPORTER_CASE_CHANGES}" unless SUPPORTER_CASE_CHANGES.include?(type)
      case hash
      when Array
        hash.map { |v| deep_change_case(v, type) }
      when Hash
        hash.each_with_object({}) do |(k, v), new_hash|
          new_key = type == :underscore ? underscore(k.to_s) : camelize(k.to_s, false)
          new_hash[new_key] = deep_change_case(v, type)
        end
      else
        hash
      end
    end

    def self.camelize(string, uppercase_first_letter = true)
      string = if uppercase_first_letter
                 string.sub(/^[a-z\d]*/) { $&.capitalize }
               else
                 string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
               end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }.gsub("/", "::")
    end

    def self.underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      camel_cased_word.to_s.gsub(/::/, "/")
                      .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .tr("-", "_")
                      .downcase
    end
  end
end
