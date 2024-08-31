RSpec.describe 'SfCli::Sf::Core::Base' do
  module Hoge; end
  Hoge::Core = Class.new do
                    include ::SfCli::Sf::Core::Base
                  end

  let(:test_object) { Hoge::Core.new }

  describe '#exec' do
    before do
      allow(test_object).to receive(:`).with('sf hoge generate --name MyProject --json --manifest 2> /dev/null').and_return(command_response)
    end
    
    it 'executes a shell command operation' do
      test_object.__send__(:exec, :generate, flags: {:"name" => 'MyProject'}, switches: {manifest: true}, redirection: :null_stderr)
      expect(test_object).to have_received :`
    end

    it 'returns a Hash object, which represents the sf command response' do
      result = test_object.__send__(:exec, :generate, flags: {:"name" => 'MyProject'}, switches: {manifest: true}, redirection: :null_stderr)
      expect(result).to be_instance_of Hash
    end
  end

  describe '#field_value_pairs' do
    it "joins each key and value with '='" do
      expect(test_object.__send__ :field_value_pairs, {a: 100}).to eq 'a=100'
    end

    it "joins each converted pairs with white space" do
      expect(test_object.__send__(:field_value_pairs, {a: 100, b: 200})).to eq 'a=100 b=200'
    end

    context 'when value is a string object' do
      it "puts single quatation around the value" do
        expect(test_object.__send__ :field_value_pairs, {a: 'abc'}).to eq "a='abc'"
      end

      it 'can convert and join pairs regardless the value is string or not' do
        expect(test_object.__send__ :field_value_pairs, {
          a: 'abc',
          b: 100,
          'c' => 500,
          'd' => "I am here",
        })
        .to eq "a='abc' b=100 c=500 d='I am here'"
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
