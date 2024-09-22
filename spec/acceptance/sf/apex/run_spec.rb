require 'stringio'
require 'tempfile'

RSpec.describe 'sf apex run' do
  let(:path) { 'path/to/file'}

  before do
    allow_any_instance_of(Tempfile).to receive(:path).and_return('sf_apex_file')
  end

  it 'executes apex codes in a file' do
    allow_any_instance_of(SfCli::Sf::Apex::Core).to receive(:`).with("sf apex run --file #{path} --json 2> /dev/null").and_return(command_response)

    result = sf.apex.run file: path
    expect(result.success).to be true
    expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
  end

  example 'executing by particular API version' do
    allow_any_instance_of(SfCli::Sf::Apex::Core).to receive(:`).with("sf apex run --file #{path} --api-version 61.0 --json 2> /dev/null").and_return(command_response)

    result = sf.apex.run file: path, api_version: 61.0
    expect(result.success).to be true
    expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
  end

  example 'Using StringIO instead of path' do
    allow_any_instance_of(SfCli::Sf::Apex::Core).to receive(:`).with("sf apex run --file sf_apex_file --json 2> /dev/null").and_return(command_response)

    pseudo_file = StringIO.new <<~EOS
                    System.debug('abc');
                  EOS

    result = sf.apex.run file: pseudo_file
    expect(result.success).to be true
    expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
  end

  example 'interactive mode' do
    $stdin = File.open(File.expand_path('../../../../support/apex/input.apex', __FILE__), 'r')

    allow_any_instance_of(SfCli::Sf::Apex::Core).to receive(:`).with("sf apex run --file sf_apex_file --json 2> /dev/null").and_return(command_response)

    result = sf.apex.run

    expect(result.success).to be true
    expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
  ensure
    $stdin = STDIN
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "success": true,
          "compiled": true,
          "compileProblem": "",
          "exceptionMessage": "",
          "exceptionStackTrace": "",
          "line": -1,
          "column": -1,
          "logs": "61.0 APEX_CODE,DEBUG;APEX_PROFILING,INFO\\nExecute Anonymous: System.debug('abc');\\n"
        },
        "warnings": []
      }
    JSON
  end
end
