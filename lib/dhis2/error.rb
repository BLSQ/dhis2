# frozen_string_literal: true

module Dhis2
  class Error < StandardError; end
  class CreationError < Error; end
  class UpdateError   < Error; end
  class PrimaryKeyMissingError < Error; end
  class InvalidRequestError < Error; end
  class CaseError < Error; end
  class InvalidVersionError < Error; end
  class DataElementAdditionError < Error; end
  class RequestError < Error
    attr_accessor :response
  end
end
