require 'spec_helper'

describe Dhis2::Api::Base do

  it "responds to as_jon and removes client" do
    client = Dhis2.play
    params = { a: 1, b: 2 }
    object = described_class.new(client, params)
    expect(object.to_json).to eq params.to_json
  end

end