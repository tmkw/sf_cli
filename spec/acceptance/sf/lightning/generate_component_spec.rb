require 'spec_helper'

RSpec.describe 'sf lightning generate component' do
  let(:component_name) { 'MyComponent' }
  let(:type) { nil }
  let(:output_dir) { nil }
  let(:template) { nil }
  let(:api_version) { nil }
  let(:output_format) { ' --json' }
  let(:redirection) { ' 2> /dev/null' }
  let(:output) { aura_response }

  before do
    allow_any_instance_of(SfCli::Sf::Lightning::Core)
      .to receive(:`)
      .with("sf lightning generate component --name #{component_name}#{type}#{output_dir}#{template}#{api_version}#{output_format}#{redirection}")
      .and_return(output)
  end

  it "creates a component (Aura)" do
    expect(sf.lightning.generate_component component_name).to contain_exactly('path/to/dir/MyCmp.cmp', 'path/to/dir/MyCmp.cmp-meta.xml')
  end

  context 'using option: type lwc' do
    let(:type) { ' --type lwc' }
    let(:output) { lwc_response }

    it "creates lwc files into the directory" do
      expect(sf.lightning.generate_component component_name, type: :lwc).to contain_exactly('path/to/dir/MyLWC.js', 'path/to/dir/MyLWC.js-meta.xml')
    end
  end

  context 'using option: output-dir' do
    let(:output_dir) { ' --output-dir path/to/dir' }
    it "creates files into the directory" do
      sf.lightning.generate_component component_name, output_dir: 'path/to/dir'
    end
  end

  context 'using option: template' do
    let(:template) { ' --template default' }
    it "creates files according to the template" do
      sf.lightning.generate_component component_name, template: :default
    end
  end

  context 'using option: api-version' do
    let(:api_version) { ' --api-version 62.0' }
    it "creates files using particular api version" do
      sf.lightning.generate_component component_name, api_version: 62.0
    end
  end

  context 'using option: raw_output' do
    let(:output_format) { '' }
    let(:redirection) { '' }
    let(:result) { anything } # same as the original command output

    it "creates files and outputs messages as same as the original command's one" do
      sf.lightning.generate_component component_name, raw_output: true
    end
  end

  def aura_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "path/to/dir",
          "created": [
            "path/to/dir/MyCmp.cmp",
            "path/to/dir/MyCmp.cmp-meta.xml"
          ],
          "rawOutput": "target dir = path/to/dir\\n  create path/to/dir/MyCmp.cmp\\n  create path/to/dir/MyCmp.cmp-meta.xml\\n"
        },
        "warnings": []
      }
    JSON
  end

  def lwc_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "path/to/dir",
          "created": [
            "path/to/dir/MyLWC.js",
            "path/to/dir/MyLWC.js-meta.xml"
          ],
          "rawOutput": "target dir = path/to/dir\\n  create path/to/dir/MyLWC.js\\n  create path/to/dir/MyLWC.js-meta.xml\\n"
        },
        "warnings": []
      }
    JSON
  end
end
