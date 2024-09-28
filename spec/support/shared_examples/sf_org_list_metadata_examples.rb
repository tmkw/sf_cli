RSpec.shared_examples 'sf org list metadata' do
  it "lists the metadata in the org" do
    list = subject
    expect(list.names).to contain_exactly(
      'CommunitiesSelfRegController',
      'SiteLoginControllerTest',
    )

    metadata = list.find :CommunitiesSelfRegController
    expect(metadata.file_name).to eq "classes/CommunitiesSelfRegController.cls"
    expect(metadata.full_name).to eq "CommunitiesSelfRegController"
    expect(metadata.type).to eq      "ApexClass"
  end
end
