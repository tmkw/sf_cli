RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#list'do
    before do
      allow(org).to receive(:exec).with(
        :list,
        flags: {
        },
        redirection: :null_stderr
      )
      .and_return(list_response)
    end

    it "lists the org the user is related to" do
      org_list = org.list
      expect(org_list.size).to be 5
      expect(org).to have_received :exec
    end

    it "lists the org, which each org is unique" do
      org_list = org.list
      expect(org_list.map(&:alias)).to contain_exactly('prod', 'sandbox01', 'sandbox02', 'dev', 'scratch01')
    end
  end

  def list_response
    {
      "status" => 0,
      "result" => {
        "other" => [
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "prod",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          }
        ],
        "sandboxes" => [
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "sandbox01",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          },
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "sandbox02",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          }
        ],
        "nonScratchOrgs" => [
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "dev",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          },
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "sandbox01",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          },
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "sandbox02",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          }
        ],
        "devHubs" => [
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "dev",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          }
        ],
        "scratchOrgs" => [
          {
            "accessToken" => "hoge",
            "instanceUrl" => "https://foo-baz-bar.develop.my.salesforce.com",
            "orgId" => "some org id",
            "username" => "user@example.sandbox",
            "loginUrl" => "https://foo-baz-bar.develop.my.salesforce.com/",
            "clientId" => "PlatformCLI",
            "isDevHub" => true,
            "instanceApiVersion" => "61.0",
            "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
            "name" => "free",
            "instanceName" => "XX62",
            "namespacePrefix" => nil,
            "isSandbox" => false,
            "isScratch" => false,
            "trailExpirationDate" => nil,
            "tracksSource" => false,
            "alias" => "scratch01",
            "isDefaultDevHubUsername" => false,
            "isDefaultUsername" => false,
            "lastUsed" => "2024-09-07T13:14:50.368Z",
            "connectedStatus" => "Connected"
          }
        ]
      },
      "warnings" => []
    }
  end
end
