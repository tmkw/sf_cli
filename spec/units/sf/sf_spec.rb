RSpec.describe 'SfCli::Sf' do
  let(:sf) { SfCli::Sf.new }

  it "has a getter method 'org' for 'sf org' operation" do
    expect(sf.methods).to include :org
  end

  it "has a getter method 'data' for 'sf data' operation" do
    expect(sf.methods).to include :data
  end

  it "has a getter method 'sobject' for 'sf sobject' operation" do
    expect(sf.methods).to include :sobject
  end

  it "has a getter method 'project' for 'sf project' operation" do
    expect(sf.methods).to include :project
  end

  describe '#exec' do
    before do
      allow(sf).to receive(:`).with('sf project generate --name MyProject --json --manifest 2> /dev/null').and_return(command_response)
    end
    
    it 'executes a shell command operation' do
      sf.exec(:project, :generate, flags: {:"name" => 'MyProject'}, switches: {manifest: true}, redirection: :null_stderr)
      expect(sf).to have_received :`
    end

    it 'returns a Hash object, which represents the sf command response' do
      result = sf.exec(:project, :generate, flags: {:"name" => 'MyProject'}, switches: {manifest: true}, redirection: :null_stderr)
      expect(result).to be_instance_of Hash
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "/foo/baz/bar",
          "created": [
            "TestProject/sfdx-project.json",
            "TestProject/manifest/package.xml",
            "TestProject/package.json"
          ],
          "rawOutput": "ROW OUTPUT INFORMATION OF COMMAND"
        },
        "warnings": []
      }
    JSON
  end
end
