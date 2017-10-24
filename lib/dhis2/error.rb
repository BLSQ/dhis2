# frozen_string_literal: true

module Dhis2
  class Error < StandardError; end
  class CreationError < Error; end
  class UpdateError   < Error; end
end