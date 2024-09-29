require_relative '../../../support/shared_examples/sf_org_list_metadata_examples'

RSpec.describe 'sf org list metadata' do
  let(:command_options) { nil }

  before do
    allow_any_instance_of(SfCli::Sf::Org::Core)
      .to receive(:`)
      .with("sf org list metadata --metadata-type ApexClass #{command_options}--json 2> /dev/null")
      .and_return(command_response)
  end

  it_should_behave_like 'sf org list metadata' do
    subject { sf.org.list_metadata :ApexClass}
  end

  context 'specfying folder:' do
    it_should_behave_like 'sf org list metadata' do
      let(:command_options) { '--folder folder_name ' }
      subject { sf.org.list_metadata :ApexClass, folder: :folder_name  }
    end
  end

  context 'specfying target-org:' do
    it_should_behave_like 'sf org list metadata' do
      let(:command_options) { '--target-org dev ' }
      subject { sf.org.list_metadata :ApexClass, target_org: :dev }
    end
  end

  context 'specfying api-version:' do
    it_should_behave_like 'sf org list metadata' do
      let(:command_options) { '--api-version 61.0 ' }
      subject { sf.org.list_metadata :ApexClass, api_version: 61.0 }
    end
  end

  context 'specfying output-file:' do
    it_should_behave_like 'sf org list metadata' do
      let(:command_options) { '--output-file path/to/file ' }
      subject { sf.org.list_metadata :ApexClass, output_file: 'path/to/file' }
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": [
            {
              "createdById": "0055j00000AUSsWAAX",
              "createdByName": "hoge fuga",
              "createdDate": "2024-03-26T02:14:01.000Z",
              "fileName": "classes/CommunitiesSelfRegController.cls",
              "fullName": "CommunitiesSelfRegController",
              "id": "01p5j00000exwcLAAQ",
              "lastModifiedById": "0055j00000AUSsWAAX",
              "lastModifiedByName": "hoge fuga",
              "lastModifiedDate": "2024-03-26T02:14:01.000Z",
              "manageableState": "unmanaged",
              "type": "ApexClass"
            },
            {
              "createdById": "0055j00000AUSsWAAX",
              "createdByName": "hoge fuga",
              "createdDate": "2024-03-26T02:14:01.000Z",
              "fileName": "classes/SiteLoginControllerTest.cls",
              "fullName": "SiteLoginControllerTest",
              "id": "01p5j00000exwcLAAQ",
              "lastModifiedById": "0055j00000AUSsWAAX",
              "lastModifiedByName": "hoge fuga",
              "lastModifiedDate": "2024-03-26T02:14:01.000Z",
              "manageableState": "unmanaged",
              "type": "ApexClass"
            }
        ],
        "warnings": []
      }
    JSON
  end
end
