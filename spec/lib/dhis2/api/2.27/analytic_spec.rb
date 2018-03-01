# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version227::Analytic do
  it_behaves_like "an analytic endpoint", version: "2.27"
end
