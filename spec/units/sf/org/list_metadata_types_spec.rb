RSpec.describe 'SfCli::Sf::Org' do
  let(:org) { SfCli::Sf::Org::Core.new }

  describe '#list_metadata_types' do
    let(:target_org ) { nil }
    let(:api_version) { nil }
    let(:path) { nil }

    before do
      allow(org)
        .to receive(:exec)
        .with('list metadata-types', flags: {:"target-org" => target_org, :"api-version" => api_version, :"output-file" => path}, redirection: :null_stderr)
        .and_return(exec_output)
    end

    it "lists the metadata types in the org" do
      result = org.list_metadata_types
      expect(result.metadata_objects.count).to be 1
      expect(result.metadata_objects.names).to eq ['InstalledPackage']

      expect(org).to have_received :exec
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "lists the metadata types in the org" do
        org.list_metadata_types target_org: :dev
        expect(org).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'can get a paticular org information' do
        org.list_metadata_types api_version: 61.0
        expect(org).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "metadataObjects" => [
          {
            "directoryName" => "installedPackages",
            "inFolder" => false,
            "metaFile" => false,
            "suffix" => "installedPackage",
            "xmlName" => "InstalledPackage",
            "childXmlNames" => []
          }
        ],
        "organizationNamespace" => "",
        "partialSaveAllowed" => true,
        "testRequired" => false
      },
      "warnings" => []
    }
  end
end
