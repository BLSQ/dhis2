# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version226::ResourceTable do
  it_behaves_like "a resource table", version: "2.26"
end
