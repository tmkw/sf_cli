RSpec.describe 'SfCli::Sf::Core::OrgBase' do
  module HogeOrg; end
  HogeOrg::Core = Class.new do
                    include ::SfCli::Sf::Core::OrgBase
                  end

  let(:test_object) { HogeOrg::Core.new }

  describe '#org_exec' do
    let(:raw_output_flg) { false }
    let(:redirect_type) { :null_stderr }
    let(:command_output_format) { :json }

    before do
      allow(test_object)
        .to receive(:exec)
        .with(:display, flags: {:"target-org" => 'dev'}, switches: {hoge: true}, redirection: redirect_type, raw_output: raw_output_flg, format: command_output_format)
        .and_return(command_response)
    end

    it 'returns json formatted data' do
      test_object.__send__(:org_exec, :display, flags: {:"target-org" => 'dev'}, switches: {hoge: true}, redirection: redirect_type, raw_output: false)
      expect(test_object).to have_received(:exec)
    end

    context 'in case of raw_output option enabled' do
      let(:raw_output_flg) { true }
      let(:redirect_type) { nil }
      let(:command_output_format) { :human }

      it 'returns the result formatted as same as original command outputs' do
        test_object.__send__(:org_exec, :display, flags: {:"target-org" => 'dev'}, switches: {hoge: true}, redirection: redirect_type, raw_output: true)
        expect(test_object).to have_received(:exec)
      end
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "outputDir": "/foo/baz/bar",
          "created": [
            "TestProject/sfdx-project.json",
            "TestProject/manifest/package.xml",
            "TestProject/package.json"
          ],
          "rawOutput": "ROW OUTPUT INFORMATION OF COMMAND"
        },
        "warnings": []
      }
    JSON
  end
end
