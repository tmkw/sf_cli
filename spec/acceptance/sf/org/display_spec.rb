require 'spec_helper'

RSpec.describe 'sf.org.display' do
  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "id": "foobazbar",
          "apiVersion": "61.0",
          "accessToken": "THIS IS ACCESS TOKEN",
          "instanceUrl": "https://hoge.example.com",
          "username": "user@example.sandbox",
          "clientId": "PlatformCLI",
          "connectedStatus": "Connected",
          "alias": "dev"
        },
        "warnings": [
          "this is warning"
        ]
      }
    JSON
  end

  it "returns the current connection information of the org" do
    sf = SfCli::Sf.new
    allow(sf).to receive(:`).with('sf org display --json 2> dev/null').and_return(command_response)

    connection_info = sf.org.display

    expect(connection_info.id).to eq 'foobazbar'
    expect(connection_info.access_token).to eq 'THIS IS ACCESS TOKEN'
    expect(connection_info.instance_url).to eq 'https://hoge.example.com'
    expect(connection_info.api_version).to eq '61.0'
    expect(connection_info.user_name).to eq 'user@example.sandbox'
    expect(connection_info.status).to eq 'Connected'
    expect(connection_info.alias).to eq 'dev'

    expect(sf).to have_received(:`)
  end

  it "can return the other org's information" do
    sf = SfCli::Sf.new
    allow(sf).to receive(:`).with('sf org display --target-org dev --json 2> dev/null').and_return(command_response)

    sf.org.display target_org: 'dev'

    expect(sf).to have_received(:`)
  end
end
