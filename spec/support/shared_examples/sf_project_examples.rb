RSpec.shared_examples 'sf project retrieve start' do
  it "retrieves the source files" do
    result = subject
    expect(result).to be_success
    expect(result.file_properties.count).to be 2
    expect(result.file_properties[0].full_name).to eq 'ChangePasswordController'
    expect(result.files.count).to be 2
    expect(result.files[0].full_name).to eq 'ChangePasswordController'
    expect(result.files[0].type).to eq 'ApexClass'
    expect(result.files[0].state).to eq 'Changed'
    expect(result.files[0].file_path).to eq "/path/to/force-app/main/default/classes/ChangePasswordController.cls"
  end
end