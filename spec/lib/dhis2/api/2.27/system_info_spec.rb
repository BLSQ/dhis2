# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version227::SystemInfo do
  it_behaves_like "a system info", version: "2.27"
end
