require 'spec_helper'

RSpec.describe 'sf org login web' do
  let(:browser_name) { "chrome" }

  it "connects to the login page for authentication of the org" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with('sf org login web --json').and_return(command_response)

    sf.org.login_web
  end

  it "can connects particular org" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with('sf org login web --alias dev --json').and_return(command_response)

    sf.org.login_web target_org: :dev
  end

  it "can login at the non standard url (ex. test.salesforce.com, etc)" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with('sf org login web --instance-url https://test.salesforce.com --json').and_return(command_response)

    sf.org.login_web instance_url: 'https://test.salesforce.com'
  end

  it "can mix target org and url to login" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with('sf org login web --alias dev --instance-url https://test.salesforce.com --json').and_return(command_response)

    sf.org.login_web target_org: :dev, instance_url: 'https://test.salesforce.com'
  end

  it "can use paticular browser for login operation" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with("sf org login web --browser #{browser_name} --json").and_return(command_response)

    sf.org.login_web browser: browser_name
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
