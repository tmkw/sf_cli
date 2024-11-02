RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#list_limits' do
    let(:target_org ) { nil }
    let(:api_version) { nil }

    before do
      allow(org)
        .to receive(:org_exec)
        .with(
          'list limits',
          flags: {
            :"target-org" => target_org,
            :"api-version" => api_version,
          },
          redirection: :null_stderr,
          format: :json)
        .and_return(exec_output)
    end

    it "lists limits in the org" do
      limits = org.list_limits
      expect(limits.names).to contain_exactly(
        'PermissionSets',
        'PrivateConnectOutboundCalloutHourlyLimitMB',
      )
      limit = limits.find :PermissionSets
      expect(limit.max).to eq 1500
      expect(limit.remaining).to eq 1498

      expect(org).to have_received :org_exec
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "lists limits in particular org" do
        org.list_limits target_org: :dev
        expect(org).to have_received :org_exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'lists limits by paticular API version' do
        org.list_limits api_version: 61.0
        expect(org).to have_received :org_exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => [
        {
          "name" => "PermissionSets",
          "max" => 1500,
          "remaining" => 1498
        },
        {
          "name" => "PrivateConnectOutboundCalloutHourlyLimitMB",
          "max" => 0,
          "remaining" => 0
        }
      ],
      "warnings" => []
    }
  end
end
