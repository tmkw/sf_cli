RSpec.shared_examples 'sf org list metadata-types' do
  it "lists the metadata types in the org" do
    result = subject
    expect(result.metadata_objects.count).to be 1
    expect(result.metadata_objects.names).to eq ['InstalledPackage']
  end
end
