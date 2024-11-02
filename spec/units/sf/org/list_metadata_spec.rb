RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#list_metadata' do
    let(:metadata_type ) { :ApexClass }
    let(:folder_name ) { nil }
    let(:target_org ) { nil }
    let(:api_version) { nil }
    let(:path) { nil }
    let(:raw_output_flg) { false }

    before do
      allow(org)
        .to receive(:org_exec)
        .with(
          'list metadata',
          flags: {
            :"metadata-type" => metadata_type,
            :"folder" => folder_name,
            :"target-org" => target_org,
            :"api-version" => api_version,
            :"output-file" => path
          },
          redirection: :null_stderr,
          raw_output: raw_output_flg)
        .and_return(exec_output)
    end

    it "lists metadata in the org" do
      list = org.list_metadata metadata_type
      expect(list.names).to contain_exactly(
        'CommunitiesSelfRegController',
        'SiteLoginControllerTest',
      )
      metadata = list.find :CommunitiesSelfRegController
      expect(metadata.file_name).to eq "classes/CommunitiesSelfRegController.cls"
      expect(metadata.full_name).to eq "CommunitiesSelfRegController"
      expect(metadata.type).to eq      "ApexClass"

      expect(org).to have_received :org_exec
    end

    context 'using option: folder' do
      let(:folder_name) { :folder_name }

      it "lists metadata in the folder" do
        org.list_metadata metadata_type, folder: folder_name
        expect(org).to have_received :org_exec
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "lists metadata in particular org" do
        org.list_metadata metadata_type, target_org: :dev
        expect(org).to have_received :org_exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'lists metadata by paticular API version' do
        org.list_metadata metadata_type, api_version: 61.0
        expect(org).to have_received :org_exec
      end
    end

    context 'using option: output_file' do
      let(:path) { 'path/to/file' }

      it 'saves the result to a file' do
        org.list_metadata metadata_type, output_file: path
        expect(org).to have_received :org_exec
      end
    end

    context 'using option: raw_output' do
      let(:raw_output_flg) { true }

      it 'saves the result to a file' do
        org.list_metadata metadata_type, raw_output: true
        expect(org).to have_received :org_exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => [
          {
            "createdById" => "0055j00000AUSsWAAX",
            "createdByName" => "hoge fuga",
            "createdDate" => "2024-03-26T02:14:01.000Z",
            "fileName" => "classes/CommunitiesSelfRegController.cls",
            "fullName" => "CommunitiesSelfRegController",
            "id" => "01p5j00000exwcLAAQ",
            "lastModifiedById" => "0055j00000AUSsWAAX",
            "lastModifiedByName" => "hoge fuga",
            "lastModifiedDate" => "2024-03-26T02:14:01.000Z",
            "manageableState" => "unmanaged",
            "type" => "ApexClass"
          },
          {
            "createdById" => "0055j00000AUSsWAAX",
            "createdByName" => "hoge fuga",
            "createdDate" => "2024-03-26T02:14:01.000Z",
            "fileName" => "classes/SiteLoginControllerTest.cls",
            "fullName" => "SiteLoginControllerTest",
            "id" => "01p5j00000exwcLAAQ",
            "lastModifiedById" => "0055j00000AUSsWAAX",
            "lastModifiedByName" => "hoge fuga",
            "lastModifiedDate" => "2024-03-26T02:14:01.000Z",
            "manageableState" => "unmanaged",
            "type" => "ApexClass"
          }
      ],
      "warnings" => []
    }
  end
end
