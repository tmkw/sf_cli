RSpec.describe 'SfCli::Sf::Apex' do
  let(:apex) { SfCli::Sf::Apex::Core.new }
  let(:class_name) { 'MyClass1' }
  let(:output_dir) { nil }
  let(:template) { nil }
  let(:api_version) { nil }
  let(:raw_output) { false }
  let(:command_output_format) { :json }
  let(:redirect_type) { :null_stderr }
  let(:result) { exec_output }

  describe '#generate_class' do
    before do
      allow(apex).to receive(:exec).with(
        'generate class',
        flags: {
          name:           class_name,
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
      .and_return(exec_output)
    end

    it "creates a Apex file and a metadata xml file" do
      expect(apex.generate_class class_name).to contain_exactly('path/to/dir/MyClass1.cls', 'path/to/dir/MyClass1.cls-meta.xml')
      expect(apex).to have_received :exec
    end

    context 'using option: output-dir' do
      let(:output_dir) { 'path/to/dir' }
      it "creates files into the directory" do
        apex.generate_class class_name, output_dir: output_dir
      end
    end

    context 'using option: template' do
      let(:template) { 'DefaultApexClass' }
      it "creates files according to the template" do
        apex.generate_class class_name, template: template
      end
    end

    context 'using option: api-version' do
      let(:api_version) { 62.0 }
      it "creates files using particular api version" do
        apex.generate_class class_name, api_version: api_version
      end
    end

    context 'using option: raw_output' do
      let(:command_output_format) { :human }
      let(:raw_output) { true }
      let(:redirect_type) { nil }
      let(:result) { anything } # same as the original command output

      it "creates files and outputs messages as same as the original command's one" do
        apex.generate_class class_name, raw_output: raw_output
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "outputDir" => "path/to/dir",
        "created" => [
          "path/to/dir/MyClass1.cls",
          "path/to/dir/MyClass1.cls-meta.xml"
        ],
        "rawOutput" => "target dir = path/to/dir\n  create path/to/dir/MyClass1.cls\n  create path/to/dir/MyClass1.cls-meta.xml\n"
      },
      "warnings" => []
    }
  end
end
