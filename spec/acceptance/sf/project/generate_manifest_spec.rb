require 'spec_helper'

RSpec.describe 'sf project generate manifest' do
  it "create the manifest file of Salesforce DX project with a paticular metadata name" do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --metadata CustomObject --json 2> /dev/null').and_return(command_response)

    expect(sf.project.generate_manifest metadata: %w[CustomObject]).to eq 'package.xml'
  end

  it 'can create a manifest file with paticular name' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --name hoge.xml --metadata CustomObject --json 2> /dev/null').and_return(command_response name: 'hoge.xml')

    expect(sf.project.generate_manifest name: 'hoge.xml', metadata: %w[CustomObject]).to eq 'hoge.xml'
  end

  it 'can create a manifest file at paticular directory' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --metadata CustomObject --output-dir tmp --json 2> /dev/null').and_return(command_response output_dir: 'tmp')

    expect(sf.project.generate_manifest output_dir: 'tmp', metadata: %w[CustomObject]).to eq 'tmp/package.xml'
  end

  it 'can include multiple metadata types in a manifest file' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --metadata CustomObject Report --json 2> /dev/null').and_return(command_response)

    sf.project.generate_manifest metadata: %w[CustomObject Report]
  end

  it 'can put all metadata types of paticular org into a manifest file' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --from-org hoge --json 2> /dev/null').and_return(command_response)

    sf.project.generate_manifest from_org: :hoge
  end

  it 'can put all metadata types in paticular source directory into a manifest file' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --source-dir force-app --json 2> /dev/null').and_return(command_response)

    sf.project.generate_manifest source_dir: 'force-app'
  end

  it 'can set paticular API version in the manifest file' do
    allow_any_instance_of(SfCli::Sf::Project::Core).to receive(:`).with('sf project generate manifest --metadata CustomObject --api-version 61.0 --json 2> /dev/null').and_return(command_response)

    sf.project.generate_manifest metadata: %w[CustomObject], api_version: 61.0
  end

  def command_response(name: 'package.xml', output_dir: nil)
    <<~JSON
      {
        "status": 0,
        "result": {
          "path": "#{output_dir.nil? ? '' : %|#{output_dir}/|}#{name}",
          "name": "#{name}"
        },
        "warnings": []
      }
    JSON
  end
end
