require 'spec_helper'

RSpec.describe 'sf org login_web' do
  let(:sf) { SfCli::Sf.new }

  it "connects to the login page for authentication of the org" do
    allow(sf).to receive(:`).with('sf org login web --json').and_return(command_response)

    sf.org.login_web

    expect(sf).to have_received(:`)
  end

  it "can connects particular org" do
    allow(sf).to receive(:`).with('sf org login web --alias dev --json').and_return(command_response)

    sf.org.login_web target_org: :dev

    expect(sf).to have_received(:`)
  end

  it "can login at the non standard url (ex. test.salesforce.com, etc)" do
    allow(sf).to receive(:`).with('sf org login web --instance-url https://test.salesforce.com --json').and_return(command_response)

    sf.org.login_web instance_url: 'https://test.salesforce.com'

    expect(sf).to have_received(:`)
  end

  it "can mix target org and url to login" do
    sf = SfCli::Sf.new
    allow(sf).to receive(:`).with('sf org login web --alias dev --instance-url https://test.salesforce.com --json').and_return(command_response)

    sf.org.login_web target_org: :dev, instance_url: 'https://test.salesforce.com'

    expect(sf).to have_received(:`)
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "accessToken": "THIS IS ACCESS TOKEN",
          "instanceUrl": "https://hoge.example.salesforce.com",
          "orgId": "org ID",
          "username": "usarname@example.sandbox",
          "loginUrl": "https://test.salesforce.com/",
          "refreshToken": "refresh token",
          "clientId": "PlatformCLI",
          "isDevHub": true,
          "instanceApiVersion": "61.0",
          "instanceApiVersionLastRetrieved": "2024/8/23 2:12:55",
          "name": "free",
          "instanceName": "XX62",
          "namespacePrefix": null,
          "isSandbox": false,
          "isScratch": false,
          "trailExpirationDate": null,
          "tracksSource": false
        },
        "warnings": []
      }
    JSON
  end
end
