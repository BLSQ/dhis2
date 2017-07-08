# frozen_string_literal: true

RSpec.describe Dhis2::Api::User do
  let(:user_id) { "DXyJmlo9rge"}
  it "should list users" do
    stub_request(:get, "https://play.dhis2.org/demo/api/users?fields=:all&pageSize=1").
      to_return(status: 200, body: fixture_content(:dhis2, "users.json"))

    users = Dhis2.client.users.list(fields: :all, page_size: 1)
    expect(users.size).to eq 1

    user = users.first

    expect(user.display_name).to eq "John Barnes"
    expect(user.id).to eq user_id
    expect(user.first_name).to eq "John"
    expect(user.surname).to eq "Barnes"
  end

  it "should find user by id" do
    stub_request(:get, "https://play.dhis2.org/demo/api/users/#{user_id}").
        to_return(status: 200, body: fixture_content(:dhis2, "user_#{user_id}.json"))

    user = Dhis2.client.users.find(user_id)

    expect(user.display_name).to eq "John Barnes"
    expect(user.id).to eq user_id
    expect(user.first_name).to eq "John"
  end

end
