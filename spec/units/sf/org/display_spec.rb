RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#display' do
    it "returns the current connection information of the org" do
      allow(org).to receive(:org_exec).with(:display, flags: {:"target-org" => nil, :"api-version" => nil}, redirection: :null_stderr, raw_output: false).and_return(exec_output)

      connection_info = org.display

      expect(connection_info.id).to eq 'foobazbar'
      expect(connection_info.access_token).to eq 'THIS IS ACCESS TOKEN'
      expect(connection_info.instance_url).to eq 'https://hoge.example.com'
      expect(connection_info.api_version).to eq '61.0'
      expect(connection_info.user_name).to eq 'user@example.sandbox'
      expect(connection_info.status).to eq 'Connected'
      expect(connection_info.alias).to eq 'dev'

      expect(org).to have_received :org_exec
    end

    context 'using option: target_org' do
      it 'can get a paticular org information' do
        allow(org).to receive(:org_exec).with(:display, flags: {:"target-org" => :dev, :"api-version" => nil}, redirection: :null_stderr, raw_output: false).and_return(exec_output)
        org.display target_org: :dev

        expect(org).to have_received :org_exec
      end
    end

    context 'using option: api_version' do
      it 'can get a paticular org information' do
        allow(org).to receive(:org_exec).with(:display, flags: {:"target-org" => nil, :"api-version" => 61.0}, redirection: :null_stderr, raw_output: false).and_return(exec_output)
        org.display api_version: 61.0

        expect(org).to have_received :org_exec
      end
    end

    context 'using option: raw_output' do
      it 'returns the original output of the command' do
        allow(org).
          to receive(:org_exec)
          .with(:display, flags: {:"target-org" => nil, :"api-version" => nil}, redirection: :null_stderr, raw_output: true)
          .and_return(original_command_output)

        org.display raw_output: true

        expect(org).to have_received :org_exec
      end
    end
  end

  def original_command_output
    "the result of sf org display"
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
