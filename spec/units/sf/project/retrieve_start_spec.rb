RSpec.describe 'SfCli::Sf::Project' do
  let(:project) { SfCli::Sf::Project::Core.new }

  describe '#retrieve_start' do
    let(:metadata ) { 'ApexClass' }
    let(:manifest ) { nil }
    let(:source_dir ) { nil }
    let(:package_name ) { nil }
    let(:target_org ) { nil }
    let(:output_dir) { nil }
    let(:api_version) { nil }
    let(:wait) { nil }
    let(:target_metadata_dir) { nil }
    let(:zip_file_name) { nil }
    let(:ignore_conflicts) { false }
    let(:single_package) { false }
    let(:unzip) { false }
    let(:redirect_type) { :null_stderr }
    let(:raw_output) { false }
    let(:command_output_format) { :json }

    before do
      allow(project)
        .to receive(:exec)
        .with(
          'retrieve start',
          flags: {
            :"metadata" => metadata,
            :"manifest" => manifest,
            :"source-dir" => source_dir,
            :"package-name" => package_name,
            :"target-org" => target_org,
            :"output-dir" => output_dir,
            :"api-version" => api_version,
            :"wait" => wait,
            :"target-metadata-dir" => target_metadata_dir,
            :"zip-file-name" => zip_file_name,
          },
          switches: {
            :"ignore-conflicts" => ignore_conflicts,
            :"single-package" => single_package,
            :"unzip" => unzip,
          },
          redirection: redirect_type,
          raw_output:  raw_output,
          format:      command_output_format)
        .and_return(exec_output)
    end

    it "retrieve the source files of metadata" do
      result = project.retrieve_start metadata: [:ApexClass]

      expect(result).to be_success
      expect(result.file_properties.count).to be 2
      expect(result.file_properties[0].full_name).to eq 'ChangePasswordController'
      expect(result.files.count).to be 2
      expect(result.files[0].full_name).to eq 'ChangePasswordController'
      expect(result.files[0].type).to eq 'ApexClass'
      expect(result.files[0].state).to eq 'Changed'
      expect(result.files[0].file_path).to eq "/path/to/force-app/main/default/classes/ChangePasswordController.cls"

      expect(project).to have_received :exec
    end

    context 'specifying multiple metadata:' do
      let(:metadata ) { 'ApexClass CustomObject' }

      it "retrieve the source files of multiple metadata" do
        project.retrieve_start metadata: [:ApexClass, :CustomObject]
        expect(project).to have_received :exec
      end
    end

    context 'specifying manifest file:' do
      let(:metadata ) { nil }
      let(:manifest ) { 'path/to/file' }

      it "retrieve the source files which are written in the manifest file" do
        project.retrieve_start manifest: manifest
        expect(project).to have_received :exec
      end
    end

    context 'specifying source-dir:' do
      let(:metadata ) { nil }
      let(:source_dir ) { 'path/to/file_or_dir' }

      it "retrieve the source files whose path matches to the specified file or directory" do
        project.retrieve_start source_dir: source_dir
        expect(project).to have_received :exec
      end
    end

    context 'specifying package-name:' do
      let(:metadata ) { nil }
      let(:package_name ) { 'package_name' }

      it "retrieve the source files of a package" do
        project.retrieve_start package_name: [:package_name]
        expect(project).to have_received :exec
      end
    end

    context 'specifying multiple package-names:' do
      let(:metadata ) { nil }
      let(:package_name ) { 'package_name package_name2' }

      it "retrieve the source files of a package" do
        project.retrieve_start package_name: [:package_name, :package_name2]
        expect(project).to have_received :exec
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "retrieve the source files in particular org" do
        project.retrieve_start metadata: [metadata], target_org: :dev
        expect(project).to have_received :exec
      end
    end

    context 'using option: output_dir' do
      let(:output_dir) { 'path/to/dir' }

      it 'retrieve the source files and put the into particular directory' do
        project.retrieve_start metadata: [metadata], output_dir: output_dir
        expect(project).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'retrieve the source files by paticular API version' do
        project.retrieve_start metadata: [metadata], api_version: 61.0
        expect(project).to have_received :exec
      end
    end

    context 'using option: raw_output' do
      let(:redirect_type) { nil }
      let(:raw_output) { true }
      let(:command_output_format) { :human }

      it 'returns the result and errors as same as the original command does' do
        project.retrieve_start metadata: [metadata], raw_output: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying time to wait:' do
      let(:wait) { 5 } # 5 min

      it 'waits for the command to complete retrieval until time limt comes' do
        project.retrieve_start metadata: [metadata], wait: 5
        expect(project).to have_received :exec
      end
    end

    context 'specfying target-metadata-dir:' do
      let(:target_metadata_dir) { 'path/to/dir' }

      it 'retrieves the metadata-style(zip) files and put them into  paticular directory' do
        project.retrieve_start metadata: [metadata], target_metadata_dir: 'path/to/dir'
        expect(project).to have_received :exec
      end
    end

    context 'specfying zip-file-name:' do
      let(:zip_file_name) { 'zip_file_name' }

      it 'retrieves the metadata-style(zip) file' do
        project.retrieve_start metadata: [metadata], zip_file_name: zip_file_name
        expect(project).to have_received :exec
      end
    end

    context 'specfying ignore-conflicts:' do
      let(:ignore_conflicts) { true }

      it 'retrieves the metadata-style(zip) file' do
        project.retrieve_start metadata: [metadata], ignore_conflicts: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying single-package:' do
      let(:single_package) { true }

      it do
        project.retrieve_start metadata: [metadata], single_package: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying unzip:' do
      let(:unzip) { true }

      it do
        project.retrieve_start metadata: [metadata], unzip: true
        expect(project).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "done" => true,
        "fileProperties" => [
          {
            "createdById" => "0055j00000AUSsWAAX",
            "createdByName" => "hoge fuga",
            "createdDate" => "2024-03-26T02:13:55.000Z",
            "fileName" => "unpackaged/classes/ChangePasswordController.cls",
            "fullName" => "ChangePasswordController",
            "id" => "01p5j00000exwcBAAQ",
            "lastModifiedById" => "0055j00000AUSsWAAX",
            "lastModifiedByName" => "hoge fuga",
            "lastModifiedDate" => "2024-03-26T02:13:55.000Z",
            "manageableState" => "unmanaged",
            "type" => "ApexClass"
          },
          {
            "createdById" => "0055j00000AUSsWAAX",
            "createdByName" => "hoge fuga",
            "createdDate" => "2024-09-30T10:03:07.645Z",
            "fileName" => "unpackaged/package.xml",
            "fullName" => "unpackaged/package.xml",
            "id" => "",
            "lastModifiedById" => "0055j00000AUSsWAAX",
            "lastModifiedByName" => "hoge fuga",
            "lastModifiedDate" => "2024-09-30T10:03:07.645Z",
            "manageableState" => "unmanaged",
            "type" => "Package"
          }
        ],
        "id" => "09SJ40000017HrNMAU",
        "status" => "Succeeded",
        "success" => true,
        "messages" => [],
        "files" => [
          {
            "fullName" => "ChangePasswordController",
            "type" => "ApexClass",
            "state" => "Changed",
            "filePath" => "/path/to/force-app/main/default/classes/ChangePasswordController.cls"
          },
          {
            "fullName" => "ChangePasswordController",
            "type" => "ApexClass",
            "state" => "Changed",
            "filePath" => "/path/to/force-app/main/default/classes/ChangePasswordController.cls-meta.xml"
          }
        ]
      },
      "warnings" => []
    }
  end
end
