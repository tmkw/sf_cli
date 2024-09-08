RSpec.describe 'sf org login access token' do
  let(:url) { "https://hoge-baz-foo.my.salesforce.com.example/" }
  let(:alias_name) { "dev" }

  # This methods assume you set SF_ACCESS_TOKEN envrironment variable.
  # If not, execution fails.
  it 'instructs the user to input the access token. when it is valid, login works fine' do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with("sf org login access-token --instance-url #{url} --json --no-prompt 2> /dev/null").and_return(command_response)
    sf.org.login_access_token instance_url: url
  end

  example 'login with org alias' do
    allow_any_instance_of(SfCli::Sf::Org::Core).to receive(:`).with("sf org login access-token --instance-url #{url} --alias #{alias_name} --json --no-prompt 2> /dev/null").and_return(command_response)
    sf.org.login_access_token instance_url: url, target_org: alias_name
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "accessToken": "this is access token",
          "instanceUrl": "#{url}",
          "orgId": "org id",
          "username": "user@example.sandbox",
          "loginUrl": "#{url}",
          "refreshToken": "this is refresh token",
          "clientId": "PlatformCLI",
          "isDevHub": false,
          "instanceApiVersion": "61.0",
          "instanceApiVersionLastRetrieved": "2024/9/7 22:14:50",
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
