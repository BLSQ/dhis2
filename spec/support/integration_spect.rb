RSpec.configure do |config|
  config.before(:all, type: :integration) do
    WebMock.allow_net_connect!
  end

  config.after(:all, type: :integration) do
    WebMock.disable_net_connect!
  end
end
