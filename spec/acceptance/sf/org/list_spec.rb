require 'spec_helper'

RSpec.describe 'sf org list' do
  it "lists the org the user is related to" do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with('sf org list --json 2> /dev/null').and_return(list_response)

    org_list = sf.org.list

    expect(org_list.size).to be 1
    expect(org_list.first).to have_attributes(alias: 'dev')
    expect(org_list.first).to be_connected
    expect(org_list.first).to be_devhub
  end

  def list_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "other": [
          ],
          "sandboxes": [
          ],
          "nonScratchOrgs": [
            {
              "accessToken": "hoge",
              "instanceUrl": "https://foo-baz-bar.develop.my.salesforce.com",
              "orgId": "some org id",
              "username": "user@example.sandbox",
              "loginUrl": "https://foo-baz-bar.develop.my.salesforce.com/",
              "clientId": "PlatformCLI",
              "isDevHub": true,
              "instanceApiVersion": "61.0",
              "instanceApiVersionLastRetrieved": "2024/9/7 22:14:50",
              "name": "free",
              "instanceName": "XX62",
              "namespacePrefix": null,
              "isSandbox": false,
              "isScratch": false,
              "trailExpirationDate": null,
              "tracksSource": false,
              "alias": "dev",
              "isDefaultDevHubUsername": false,
              "isDefaultUsername": false,
              "lastUsed": "2024-09-07T13:14:50.368Z",
              "connectedStatus": "Connected"
            }
          ],
          "devHubs": [
            {
              "accessToken": "hoge",
              "instanceUrl": "https://foo-baz-bar.develop.my.salesforce.com",
              "orgId": "some org id",
              "username": "user@example.sandbox",
              "loginUrl": "https://foo-baz-bar.develop.my.salesforce.com/",
              "clientId": "PlatformCLI",
              "isDevHub": true,
              "instanceApiVersion": "61.0",
              "instanceApiVersionLastRetrieved": "2024/9/7 22:14:50",
              "name": "free",
              "instanceName": "XX62",
              "namespacePrefix": null,
              "isSandbox": false,
              "isScratch": false,
              "trailExpirationDate": null,
              "tracksSource": false,
              "alias": "dev",
              "isDefaultDevHubUsername": false,
              "isDefaultUsername": false,
              "lastUsed": "2024-09-07T13:14:50.368Z",
              "connectedStatus": "Connected"
            }
          ],
          "scratchOrgs": []
        },
        "warnings": []
      }
    JSON
  end
end
