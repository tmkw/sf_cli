require 'stringio'
require 'tempfile'

RSpec.describe 'SfCli::Sf::Apex' do
  let(:apex) { SfCli::Sf::Apex::Core.new }

  describe '#run' do
    let(:path) {'path/to/file'}

    before do
      allow(apex)
        .to receive(:exec)
        .with(:run, flags: {:"target-org" => nil, file: path}, redirection: :null_stderr)
        .and_return(exec_output)
    end

    it "execute apex code in a file" do
      apex.run file: path
      expect(apex).to have_received :exec
    end

    it 'returns the execution result' do
      result = apex.run file: path
      expect(result.success).to be true
      expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
    end

    context 'Using StringIO instead of file path' do
      let(:path) { '/tmp/file' }
      let(:tempfile) { instance_double('Tempfile') }
      let(:string_io) { StringIO.new("System.debug('abc');") }

      before do
        allow(Tempfile).to receive(:open).with(%w[sf apex]).and_yield(tempfile)
        allow(tempfile).to receive(:write).with("System.debug('abc');")
        allow(tempfile).to receive(:path).and_return(path)
        allow(tempfile).to receive(:close!)
      end

      it "execute apex code by reading StringIO" do
        apex.run file: string_io

        expect(apex).to have_received :exec
        expect(tempfile).to have_received :path
        expect(tempfile).to have_received :close!
      end

      it 'returns the execution result' do
        result = apex.run file: string_io
        expect(result.success).to be true
        expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
      end
    end

    context 'with interactive mode' do
      let(:path) { '/tmp/file' }
      let(:tempfile) { instance_double('Tempfile') }
      let(:string_io) { StringIO.new("System.debug('abc');") }

      before do
        $stdin = File.open(File.expand_path('../../../../support/apex/input.apex', __FILE__), 'r')
        allow(Tempfile).to receive(:open).with(%w[sf apex]).and_yield(tempfile)
        allow(tempfile).to receive(:puts).with("System.debug('abc');\n")
        allow(tempfile).to receive(:path).and_return(path)
        allow(tempfile).to receive(:close!)
      end

      after do
        $stdin = STDIN
      end

      it "execute apex code by reading StringIO" do
        apex.run

        expect(apex).to have_received :exec
        expect(tempfile).to have_received :puts
        expect(tempfile).to have_received :close!
      end

      it 'returns the execution result' do
        result = apex.run
        expect(result.success).to be true
        expect(result.logs).to include "Execute Anonymous: System.debug('abc');"
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "success" => true,
        "compiled" => true,
        "compileProblem" => "",
        "exceptionMessage" => "",
        "exceptionStackTrace" => "",
        "line" => -1,
        "column" => -1,
        "logs" => "61.0 APEX_CODE,DEBUG;APEX_PROFILING,INFO\nExecute Anonymous: System.debug('abc');\n"
      },
      "warnings" => []
    }
  end
end
