RSpec.describe 'SfCli::Sf::Org' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:org) { SfCli::Sf::Org::Core.new(sf) }

  describe '#display' do
    it "returns the current connection information of the org" do
      allow(sf).to receive(:exec).with('org', :display, flags: {:"target-org" => nil}, switches: {}, redirection: :null_stderr).and_return(exec_output)

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
        allow(sf).to receive(:exec).with('org', :display, flags: {:"target-org" => :dev}, switches: {}, redirection: :null_stderr).and_return(exec_output)
        org.display target_org: :dev

        expect(sf).to have_received :exec
      end
    end
  end

  def exec_output
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
end
