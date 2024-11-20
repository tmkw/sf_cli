require 'spec_helper'

RSpec.describe 'sf apex generate class' do
  let(:class_name) { 'MyClass1' }
  let(:output_dir) { nil }
  let(:template) { nil }
  let(:api_version) { nil }
  let(:output_format) { ' --json' }
  let(:redirection) { ' 2> /dev/null' }
  let(:result) { command_response }

  before do
    allow_any_instance_of(SfCli::Sf::Apex::Core)
      .to receive(:`)
      .with("sf apex generate class --name #{class_name}#{output_dir}#{template}#{api_version}#{output_format}#{redirection}")
      .and_return(command_response)
  end

  it "creates a Apex file and a metadata xml file" do
    expect(sf.apex.generate_class 'MyClass1').to contain_exactly('path/to/dir/MyClass1.cls', 'path/to/dir/MyClass1.cls-meta.xml')
  end

  context 'using option: output-dir' do
    let(:output_dir) { ' --output-dir path/to/dir' }
    it "creates files into the directory" do
      sf.apex.generate_class 'MyClass1', output_dir: 'path/to/dir'
    end
  end

  context 'using option: template' do
    let(:template) { ' --template DefaultApexClass' }
    it "creates files according to the template" do
      sf.apex.generate_class 'MyClass1', template: :DefaultApexClass
    end
  end

  context 'using option: api-version' do
    let(:api_version) { ' --api-version 62.0' }
    it "creates files using particular api version" do
      sf.apex.generate_class 'MyClass1', api_version: 62.0
    end
  end

  context 'using option: raw_output' do
    let(:output_format) { '' }
    let(:redirection) { '' }
    let(:result) { anything } # same as the original command output

    it "creates files and outputs messages as same as the original command's one" do
      sf.apex.generate_class 'MyClass1', raw_output: true
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "path/to/dir",
          "created": [
            "path/to/dir/MyClass1.cls",
            "path/to/dir/MyClass1.cls-meta.xml"
          ],
          "rawOutput": "target dir = path/to/dir\\n  create path/to/dir/MyClass1.cls\\n  create path/to/dir/MyClass1.cls-meta.xml\\n"
        },
        "warnings": []
      }
    JSON
  end
end
