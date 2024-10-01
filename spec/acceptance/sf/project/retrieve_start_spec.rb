require_relative '../../../support/shared_examples/sf_project_examples'

RSpec.describe 'sf project retrieve start' do
  let(:flag_options) { '--metadata ApexClass ' }
  let(:switch_options) { '--json' }

  before do
    allow_any_instance_of(SfCli::Sf::Project::Core)
      .to receive(:`)
      .with("sf project retrieve start #{flag_options}#{switch_options} 2> /dev/null")
      .and_return(command_response)
  end

  it_should_behave_like 'sf project retrieve start' do
    subject { sf.project.retrieve_start metadata: [:ApexClass]}
  end

  context 'specifying multiple metadata:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass CustomObject ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass, :CustomObject]}
    end
  end

  context 'specifying manifest file:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--manifest path/to/file ' }
      subject { sf.project.retrieve_start manifest: 'path/to/file' }
    end
  end

  context 'specifying source-dir:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--source-dir path/to/file_or_dir ' }
      subject { sf.project.retrieve_start source_dir: 'path/to/file_or_dir' }
    end
  end

  context 'specifying package-name:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--package-name package_name ' }
      subject { sf.project.retrieve_start package_name: [:package_name] }
    end
  end

  context 'specifying multiple package-names:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--package-name package_name package_name2 ' }
      subject { sf.project.retrieve_start package_name: [:package_name, :package_name2] }
    end
  end

  context 'specfying target-org:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass --target-org dev ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], target_org: :dev}
    end
  end

  context 'specfying output-dir:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass --output-dir path/to/dir ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], output_dir: 'path/to/dir'}
    end
  end

  context 'specfying api-version:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass CustomObject --api-version 61.0 ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass, :CustomObject], api_version: 61.0}
    end
  end

  context 'specfying time to wait:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass --wait 5 ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], wait: 5}
    end
  end

  context 'specfying target-metadata-dir:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass --target-metadata-dir path/to/dir ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], target_metadata_dir: 'path/to/dir'}
    end
  end

  context 'specfying zip-file-name:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass --zip-file-name zipfile_name ' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], zip_file_name: 'zipfile_name'}
    end
  end

  context 'specfying ignore-conflicts:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --ignore-conflicts' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], ignore_conflicts: true}
    end
  end

  context 'specfying single-package:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --single-package' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], single_package: true}
    end
  end

  context 'specfying unzip:' do
    it_should_behave_like 'sf project retrieve start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --unzip' }
      subject { sf.project.retrieve_start metadata: [:ApexClass], unzip: true}
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "done": true,
          "fileProperties": [
            {
              "createdById": "0055j00000AUSsWAAX",
              "createdByName": "hoge fuga",
              "createdDate": "2024-03-26T02:13:55.000Z",
              "fileName": "unpackaged/classes/ChangePasswordController.cls",
              "fullName": "ChangePasswordController",
              "id": "01p5j00000exwcBAAQ",
              "lastModifiedById": "0055j00000AUSsWAAX",
              "lastModifiedByName": "hoge fuga",
              "lastModifiedDate": "2024-03-26T02:13:55.000Z",
              "manageableState": "unmanaged",
              "type": "ApexClass"
            },
            {
              "createdById": "0055j00000AUSsWAAX",
              "createdByName": "hoge fuga",
              "createdDate": "2024-09-30T10:03:07.645Z",
              "fileName": "unpackaged/package.xml",
              "fullName": "unpackaged/package.xml",
              "id": "",
              "lastModifiedById": "0055j00000AUSsWAAX",
              "lastModifiedByName": "hoge fuga",
              "lastModifiedDate": "2024-09-30T10:03:07.645Z",
              "manageableState": "unmanaged",
              "type": "Package"
            }
          ],
          "id": "09SJ40000017HrNMAU",
          "status": "Succeeded",
          "success": true,
          "messages": [],
          "files": [
            {
              "fullName": "ChangePasswordController",
              "type": "ApexClass",
              "state": "Changed",
              "filePath": "/path/to/force-app/main/default/classes/ChangePasswordController.cls"
            },
            {
              "fullName": "ChangePasswordController",
              "type": "ApexClass",
              "state": "Changed",
              "filePath": "/path/to/force-app/main/default/classes/ChangePasswordController.cls-meta.xml"
            }
          ]
        },
        "warnings": []
      }
    JSON
  end
end
