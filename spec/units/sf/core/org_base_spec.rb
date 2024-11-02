RSpec.describe 'SfCli::Sf::Core::OrgBase' do
  module HogeOrg; end
  HogeOrg::Core = Class.new do
                    include ::SfCli::Sf::Core::OrgBase
                  end

  let(:test_object) { HogeOrg::Core.new }

  describe '#org_exec' do
    before do
      allow(test_object)
        .to receive(:exec)
        .with(:display, flags: {:"target-org" => 'dev'}, switches: {hoge: true}, redirection: :null_stderr, raw_output: false, format: :json)
        .and_return(command_response)
    end

    it 'just invokes Base#exec' do
      test_object.__send__(:org_exec, :display, flags: {:"target-org" => 'dev'}, switches: {hoge: true}, redirection: :null_stderr, format: :json)
      expect(test_object).to have_received(:exec)
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
