require 'spec_helper'

describe Dhis2::Api::Base do

  it "removes client from hash" do
    client = Dhis2.play
    params = { a: 1, b: 2 }
    object = described_class.new(client, params)
    expect(object.to_h).to eq params
  end

end