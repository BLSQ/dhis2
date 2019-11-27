# frozen_string_literal: true

require "spec_helper"

class Capture

  def self.capture &block

    # redirect output to StringIO objects
    stdout, stderr = StringIO.new, StringIO.new
    $stdout, $stderr = stdout, stderr

    result = block.call

    # restore normal output
    $stdout, $stderr = STDOUT, STDERR

    OpenStruct.new result: result, stdout: stdout.string, stderr: stderr.string
  end
end



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

      result = Capture.capture { dhis2.post("path", { sample_payload: true }, query_param: "1") }
      expect(result.stdout).to start_with("https://admin:district@play.dhis2.org/demo/api/path?query_param=1\t{\"samplePayload\":true}\t{}\tin 0.")
    end
  end
end
