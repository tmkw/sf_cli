RSpec.describe 'SfCli::Sf::Apex' do
  let(:apex) { SfCli::Sf::Apex::Core.new }
  let(:class_name) { 'MyClass1' }
  let(:sobject) { nil }
  let(:event) { nil }
  let(:output_dir) { nil }
  let(:api_version) { nil }
  let(:raw_output) { false }
  let(:command_output_format) { :json }
  let(:redirect_type) { :null_stderr }
  let(:result) { exec_output }

  describe '#generate_trigger' do
    before do
      allow(apex).to receive(:exec).with(
        'generate trigger',
        flags: {
          name:           class_name,
          :"output-dir"   => output_dir,
          :"sobject"      => sobject,
          :"event"        => event,
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
      expect(apex.generate_trigger class_name).to contain_exactly('path/to/triggers/MyTrigger1.trigger', 'path/to/triggers/MyTrigger1.trigger-meta.xml')
      expect(apex).to have_received :exec
    end

    context 'using option: output-dir' do
      let(:output_dir) { 'path/to/dir' }
      it "creates files into the directory" do
        apex.generate_trigger class_name, output_dir: output_dir
      end
    end

    context 'using option: sobject' do
      let(:sobject) { :Account }
      it "creates the trigger on a sobject" do
        apex.generate_trigger class_name, sobject: sobject
      end
    end

    context 'using option: event' do
      let(:event) { '"before insert"' }
      it "creates the trigger for a event" do
        apex.generate_trigger class_name, event: ['before insert']
      end
    end

    context 'in case of multiple events' do
      let(:event) { '"before insert" "before update"' }
      it "creates the trigger for multiple events" do
        apex.generate_trigger class_name, event: ['before insert', 'before update']
      end
    end

    context 'using option: api-version' do
      let(:api_version) { 62.0 }
      it "creates files using particular api version" do
        apex.generate_trigger class_name, api_version: api_version
      end
    end

    context 'using option: raw_output' do
      let(:command_output_format) { :human }
      let(:raw_output) { true }
      let(:redirect_type) { nil }
      let(:result) { anything } # same as the original command output

      it "creates files and outputs messages as same as the original command's one" do
        apex.generate_trigger class_name, raw_output: raw_output
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "outputDir" => "path/to/triggers",
        "created" => [
          "path/to/triggers/MyTrigger1.trigger",
          "path/to/triggers/MyTrigger1.trigger-meta.xml"
        ],
        "rawOutput" => "target dir = path/to/triggers\n  create path/to/triggers/MyTrigger1.trigger\n  create path/to/triggers/MyTrigger1.trigger-meta.xml\n"
      },
      "warnings" => []
    }
  end
end
