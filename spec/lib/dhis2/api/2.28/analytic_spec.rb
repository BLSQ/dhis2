# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version228::Analytic do
  it_behaves_like "an analytic endpoint", version: "2.28"
end
