require 'spec_helper'

RSpec.describe 'sf project generate' do
  it "create a Salesforce DX project directory" do
    allow_any_instance_of(SfCli::Sf::Core).to receive(:`).with('sf project generate --name TestProject --json 2> /dev/null').and_return(command_response)

    result = sf.project.generate 'TestProject'

    expect(result.output_dir).to eq '/foo/baz/bar'
    expect(result.files).to include 'TestProject/sfdx-project.json'
    expect(result.raw_output).to eq 'ROW OUTPUT INFORMATION OF COMMAND'
    expect(result.warnings).to be_empty
  end

  it 'can generate manifest file (package.xml)' do
    allow_any_instance_of(SfCli::Sf::Core).to receive(:`).with('sf project generate --name TestProject --json --manifest 2> /dev/null').and_return(command_response manifest: true)

    result = sf.project.generate 'TestProject', manifest: true

    expect(result.files).to include 'TestProject/manifest/package.xml'
  end

  it 'can create the project at paticular directory' do
    allow_any_instance_of(SfCli::Sf::Core).to receive(:`).with('sf project generate --name TestProject --output-dir tmp --json 2> /dev/null').and_return(command_response output_dir: 'tmp')

    result = sf.project.generate 'TestProject', output_dir: 'tmp'

    expect(result.files).to include 'tmp/TestProject/sfdx-project.json'
  end

  it 'can create with paticular template (standard, empty or analytics)' do
    allow_any_instance_of(SfCli::Sf::Core).to receive(:`).with('sf project generate --name TestProject --template empty --json 2> /dev/null').and_return(command_response output_dir: 'tmp')

    result = sf.project.generate 'TestProject', template: 'empty'
  end

  def command_response(manifest: false, output_dir: nil)
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "/foo/baz/bar",
          "created": [
            "#{output_dir.nil? ? '' : %|#{output_dir}/|}TestProject/sfdx-project.json",
            #{ manifest ?  %("#{output_dir.nil? ? '' : %|#{output_dir}/|}TestProject/manifest/package.xml",) : '' }
            "#{output_dir.nil? ? '' : %|#{output_dir}/|}TestProject/package.json"
          ],
          "rawOutput": "ROW OUTPUT INFORMATION OF COMMAND"
        },
        "warnings": []
      }
    JSON
  end
end
