RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#login_access_token' do
    let(:url) { "https://hoge-baz-foo.my.salesforce.com.example/" }
    let(:alias_name) { nil }

    before do
      allow(org)
        .to receive(:exec)
        .with(
          'login access-token',
          flags:    {:"instance-url" => url, :"alias" => alias_name},
          switches: { :"no-prompt" => true },
          redirection: :null_stderr
        )
        .and_return(exec_output)
    end

    it "connects to the login page for authentication of the org" do
      org.login_access_token instance_url: url
      expect(org).to have_received :exec
    end

    context 'using option: target_org' do
      let(:alias_name) { :dev }

      it 'can access a paticular org' do
        org.login_access_token instance_url: url, target_org: alias_name
        expect(org).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "accessToken" => "this is access token",
        "instanceUrl" => "#{url}",
        "orgId" => "org id",
        "username" => "user@example.sandbox",
        "loginUrl" => "#{url}",
        "refreshToken" => "this is refresh token",
        "clientId" => "PlatformCLI",
        "isDevHub" => false,
        "instanceApiVersion" => "61.0",
        "instanceApiVersionLastRetrieved" => "2024/9/7 22:14:50",
        "name" => "free",
        "instanceName" => "XX62",
        "namespacePrefix" => nil,
        "isSandbox" => false,
        "isScratch" => false,
        "trailExpirationDate" => nil,
        "tracksSource" => false
      },
      "warnings" => []
    }
  end
end
