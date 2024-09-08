RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }


  describe '#login_web' do
    let(:org_alias) { nil }
    let(:instance_url) { nil }
    let(:browser_name) { nil }

    before do
      allow(org)
        .to receive(:exec)
        .with('login web', flags: {
          :"alias" => org_alias,
          :"instance-url" => instance_url,
          browser: browser_name
        })
        .and_return(exec_output)
    end

    it "connects to the login page for authentication of the org" do
      org.login_web
      expect(org).to have_received :exec
    end

    context 'using option: target_org' do
      let(:org_alias) { :dev }

      it 'can access a paticular org' do
        org.login_web target_org: org_alias
        expect(org).to have_received :exec
      end
    end

    context 'using option: instance_url' do
      let(:instance_url) { 'https://test.salesforce.com' }

      it 'can access a paticular org' do
        org.login_web instance_url: instance_url
        expect(org).to have_received :exec
      end
    end

    context 'using both options: target org and instance url' do
      let(:org_alias) { :dev }
      let(:instance_url) { 'https://test.salesforce.com' }

      it do
        org.login_web target_org: org_alias, instance_url: instance_url
        expect(org).to have_received :exec
      end
    end

    context 'using option: browser' do
      let(:browser_name) { 'chrome' }

      it 'use a paticular browser to login' do
        org.login_web browser: browser_name
        expect(org).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "accessToken" => "THIS IS ACCESS TOKEN",
        "instanceUrl" => "https://hoge.example.salesforce.com",
        "orgId" => "org ID",
        "username" => "usarname@example.sandbox",
        "loginUrl" => "https://test.salesforce.com/",
        "refreshToken" => "refresh token",
        "clientId" => "PlatformCLI",
        "isDevHub" => true,
        "instanceApiVersion" => "61.0",
        "instanceApiVersionLastRetrieved" => "2024/8/23 2:12:55",
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
