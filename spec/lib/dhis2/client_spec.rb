# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Client do
  describe "client options" do
    it "should support debug option " do
      stub_request(:post, "https://play.dhis2.org/demo/api/path?query_param=1")
        .with(body: "{\"samplePayload\":true}")
        .to_return(status: 200, body: "", headers: {})

      dhis2 = Dhis2::Client.new(
        url:      "https://play.dhis2.org/demo",
        user:     "admin",
        password: "district",
        debug:    true
      )

      expect { dhis2.post("path", { sample_payload: true }, query_param: "1") }.to output(
          "https://admin:district@play.dhis2.org/demo/api/path?query_param=1	{\"samplePayload\":true}	{}\n"
      ).to_stdout
    end
  end
end
