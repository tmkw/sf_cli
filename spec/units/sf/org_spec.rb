RSpec.describe 'SfCli::Sf::Org' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:org) { SfCli::Sf::Org.new(sf) }

  describe '#display' do
    it "returns the current connection information of the org" do
      allow(sf).to receive(:exec).with('org', :display, flags: {:"target-org" => nil}, switches: {}, redirection: :null_stderr).and_return(display_response)

      connection_info = org.display

      expect(connection_info.id).to eq 'foobazbar'
      expect(connection_info.access_token).to eq 'THIS IS ACCESS TOKEN'
      expect(connection_info.instance_url).to eq 'https://hoge.example.com'
      expect(connection_info.api_version).to eq '61.0'
      expect(connection_info.user_name).to eq 'user@example.sandbox'
      expect(connection_info.status).to eq 'Connected'
      expect(connection_info.alias).to eq 'dev'

      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can get a paticular org information' do
        allow(sf).to receive(:exec).with('org', :display, flags: {:"target-org" => :dev}, switches: {}, redirection: :null_stderr).and_return(display_response)
        org.display target_org: :dev

        expect(sf).to have_received :exec
      end
    end
  end

  describe '#login_web' do
    it "connects to the login page for authentication of the org" do
      allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => nil, :"instance-url" => nil}, switches: {}, redirection: nil).and_return(login_response)
      org.login_web
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can access a paticular org' do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => :dev, :"instance-url" => nil}, switches: {}, redirection: nil).and_return(login_response)
        org.login_web target_org: :dev

        expect(sf).to have_received :exec
      end
    end

    context 'using option: instance_url' do
      it 'can access a paticular org' do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => nil, :"instance-url" => 'https://test.salesforce.com'}, switches: {}, redirection: nil).and_return(login_response)
        org.login_web instance_url: 'https://test.salesforce.com'

        expect(sf).to have_received :exec
      end
    end

    context 'using all options' do
      it do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => :dev, :"instance-url" => 'https://test.salesforce.com'}, switches: {}, redirection: nil).and_return(login_response)
        org.login_web target_org: :dev, instance_url: 'https://test.salesforce.com'
        expect(sf).to have_received :exec
      end
    end
  end

  def display_response
    {
      "status" => 0,
      "result" => {
        "id" => "foobazbar",
        "apiVersion" => "61.0",
        "accessToken" => "THIS IS ACCESS TOKEN",
        "instanceUrl" => "https://hoge.example.com",
        "username" => "user@example.sandbox",
        "clientId" => "PlatformCLI",
        "connectedStatus" => "Connected",
        "alias" => "dev"
      },
      "warnings" => [
        "this is warning"
      ]
    }
  end

  def login_response
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
