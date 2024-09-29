require_relative '../../../support/shared_examples/sf_org_list_metadata_types_examples'

RSpec.describe 'sf org list metadata-types' do
  let(:command_options) { nil }

  before do
    allow_any_instance_of(SfCli::Sf::Org::Core)
      .to receive(:`)
      .with("sf org list metadata-types #{command_options}--json 2> /dev/null")
      .and_return(command_response)
  end

  it_should_behave_like 'sf org list metadata-types' do
    subject { sf.org.list_metadata_types }
  end

  it_should_behave_like 'sf org list metadata-types' do
    let(:command_options) { '--target-org dev ' }
    subject { sf.org.list_metadata_types target_org: :dev }
  end

  it_should_behave_like 'sf org list metadata-types' do
    let(:command_options) { '--api-version 61.0 ' }
    subject { sf.org.list_metadata_types api_version: 61.0 }
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "metadataObjects": [
            {
              "directoryName": "installedPackages",
              "inFolder": false,
              "metaFile": false,
              "suffix": "installedPackage",
              "xmlName": "InstalledPackage",
              "childXmlNames": []
            }
          ],
          "organizationNamespace": "",
          "partialSaveAllowed": true,
          "testRequired": false
        },
        "warnings": []
      }
    JSON
  end
end
