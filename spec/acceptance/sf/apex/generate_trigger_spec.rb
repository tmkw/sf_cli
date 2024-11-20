require 'spec_helper'

RSpec.describe 'sf apex generate class' do
  let(:class_name) { 'MyTrigger1' }
  let(:output_dir) { nil }
  let(:sobject) { nil }
  let(:event) { nil }
  let(:api_version) { nil }
  let(:output_format) { ' --json' }
  let(:redirection) { ' 2> /dev/null' }
  let(:result) { command_response }

  before do
    allow_any_instance_of(SfCli::Sf::Apex::Core)
      .to receive(:`)
      .with("sf apex generate trigger --name #{class_name}#{output_dir}#{sobject}#{event}#{api_version}#{output_format}#{redirection}")
      .and_return(command_response)
  end

  it "creates a Apex trigger file and a metadata xml file" do
    expect(sf.apex.generate_trigger 'MyTrigger1').to contain_exactly('path/to/triggers/MyTrigger1.trigger', 'path/to/triggers/MyTrigger1.trigger-meta.xml')
  end

  context 'using option: output-dir' do
    let(:output_dir) { ' --output-dir path/to/dir' }
    it "creates files into the directory" do
      sf.apex.generate_trigger 'MyTrigger1', output_dir: 'path/to/dir'
    end
  end

  context 'using option: sobject' do
    let(:sobject) { ' --sobject Account' }
    it "creates the trigger on a sobject" do
      sf.apex.generate_trigger 'MyTrigger1', sobject: :Account
    end
  end

  context 'using option: event' do
    let(:event) { ' --event "before insert"' }
    it "creates the trigger for a event" do
      sf.apex.generate_trigger 'MyTrigger1', event: ['before insert'] 
    end
  end

  context 'in case of multiple events' do
    let(:event) { ' --event "before insert" "before update"' }
    it "creates the trigger for multiple events" do
      sf.apex.generate_trigger 'MyTrigger1', event: ['before insert', 'before update'] 
    end
  end

  context 'using option: api-version' do
    let(:api_version) { ' --api-version 62.0' }
    it "creates files using particular api version" do
      sf.apex.generate_trigger 'MyTrigger1', api_version: 62.0
    end
  end

  context 'using option: raw_output' do
    let(:output_format) { '' }
    let(:redirection) { '' }
    let(:result) { anything } # same as the original command output

    it "creates files and outputs messages as same as the original command's one" do
      sf.apex.generate_trigger 'MyTrigger1', raw_output: true
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "path/to/triggers",
          "created": [
            "path/to/triggers/MyTrigger1.trigger",
            "path/to/triggers/MyTrigger1.trigger-meta.xml"
          ],
          "rawOutput": "target dir = path/to/triggers\\n  create path/to/triggers/MyTrigger1.trigger\\n  create path/to/triggers/MyTrigger1.trigger-meta.xml\\n"
        },
        "warnings": []
      }
    JSON
  end
end
