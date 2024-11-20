RSpec.describe 'SfCli::Sf::Lightning' do
  let(:lightning) { SfCli::Sf::Lightning::Core.new }
  let(:component_name) { 'MyClass1' }
  let(:type) { nil }
  let(:output_dir) { nil }
  let(:template) { nil }
  let(:api_version) { nil }
  let(:raw_output) { false }
  let(:command_output_format) { :json }
  let(:redirect_type) { :null_stderr }
  let(:result) { aura_output }

  describe '#generate_component' do
    before do
      allow(lightning).to receive(:exec).with(
        'generate component',
        flags: {
          name:           component_name,
          type:           type,
          :"output-dir"   => output_dir,
          :"template"     => template,
          :"api-version"  => api_version,
        },
        switches: {
        },
        redirection:  redirect_type,
        raw_output:   raw_output,
        format:       command_output_format
      )
      .and_return(result)
    end

    it "creates a component (Aura)" do
      expect(lightning.generate_component component_name).to contain_exactly('path/to/dir/MyCmp.cmp', 'path/to/dir/MyCmp.cmp-meta.xml')
      expect(lightning).to have_received :exec
    end

    context 'using option: type lwc' do
      let(:type) { :lwc }
      let(:result) { lwc_output }
      it "creates lwc files into the directory" do
        expect(lightning.generate_component component_name, type: :lwc).to contain_exactly('path/to/dir/MyLWC.js', 'path/to/dir/MyLWC.js-meta.xml')
      end
    end

    context 'using option: output-dir' do
      let(:output_dir) { 'path/to/dir' }
      it "creates files into the directory" do
        lightning.generate_component component_name, output_dir: output_dir
      end
    end

    context 'using option: template' do
      let(:template) { 'DefaultLightningClass' }
      it "creates files according to the template" do
        lightning.generate_component component_name, template: template
      end
    end

    context 'using option: api-version' do
      let(:api_version) { 62.0 }
      it "creates files using particular api version" do
        lightning.generate_component component_name, api_version: api_version
      end
    end

    context 'using option: raw_output' do
      let(:command_output_format) { :human }
      let(:raw_output) { true }
      let(:redirect_type) { nil }
      let(:result) { anything } # same as the original command output

      it "creates files and outputs messages as same as the original command's one" do
        lightning.generate_component component_name, raw_output: raw_output
      end
    end
  end

  def aura_output
    {
      "status" => 0,
      "result" => {
        "outputDir" => "path/to/dir",
        "created" => [
          "path/to/dir/MyCmp.cmp",
          "path/to/dir/MyCmp.cmp-meta.xml"
        ],
        "rawOutput" => "target dir = path/to/dir\n  create path/to/dir/MyCmp.cmp\n  create path/to/dir/MyCmp.cmp-meta.xml\n"
      },
      "warnings" => []
    }
  end

  def lwc_output
    {
      "status" => 0,
      "result" => {
        "outputDir" => "path/to/dir",
        "created" => [
          "path/to/dir/MyLWC.js",
          "path/to/dir/MyLWC.js-meta.xml"
        ],
        "rawOutput" => "target dir = path/to/dir\n  create path/to/dir/MyLWC.js\n  create path/to/dir/MyLWC.js-meta.xml\n"
      },
      "warnings" => []
    }
  end
end
