require_relative '../../../support/shared_examples/sf_org_list_limits_examples'

RSpec.describe 'sf org list limits' do
  let(:command_options) { nil }

  before do
    allow_any_instance_of(SfCli::Sf::Org::Core)
      .to receive(:`)
      .with("sf org list limits #{command_options}--json 2> /dev/null")
      .and_return(command_response)
  end

  it_should_behave_like 'sf org list limits' do
    subject { sf.org.list_limits }
  end

  context 'specfying target-org:' do
    it_should_behave_like 'sf org list limits' do
      let(:command_options) { '--target-org dev ' }
      subject { sf.org.list_limits target_org: :dev }
    end
  end

  context 'specfying api-version:' do
    it_should_behave_like 'sf org list limits' do
      let(:command_options) { '--api-version 61.0 ' }
      subject { sf.org.list_limits api_version: 61.0 }
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": [
          {
            "name": "PermissionSets",
            "max": 1500,
            "remaining": 1498
          },
          {
            "name": "PrivateConnectOutboundCalloutHourlyLimitMB",
            "max": 0,
            "remaining": 0
          }
        ],
        "warnings": []
      }
    JSON
  end
end
