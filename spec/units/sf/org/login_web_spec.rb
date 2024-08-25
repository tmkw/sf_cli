RSpec.describe 'SfCli::Sf::Org' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:org) { SfCli::Sf::Org.new(sf) }


  describe '#login_web' do
    it "connects to the login page for authentication of the org" do
      allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => nil, :"instance-url" => nil}, switches: {}, redirection: nil).and_return(exec_output)
      org.login_web
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can access a paticular org' do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => :dev, :"instance-url" => nil}, switches: {}, redirection: nil).and_return(exec_output)
        org.login_web target_org: :dev

        expect(sf).to have_received :exec
      end
    end

    context 'using option: instance_url' do
      it 'can access a paticular org' do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => nil, :"instance-url" => 'https://test.salesforce.com'}, switches: {}, redirection: nil).and_return(exec_output)
        org.login_web instance_url: 'https://test.salesforce.com'

        expect(sf).to have_received :exec
      end
    end

    context 'using all options' do
      it do
        allow(sf).to receive(:exec).with('org', 'login web', flags: {:"alias" => :dev, :"instance-url" => 'https://test.salesforce.com'}, switches: {}, redirection: nil).and_return(exec_output)
        org.login_web target_org: :dev, instance_url: 'https://test.salesforce.com'
        expect(sf).to have_received :exec
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
