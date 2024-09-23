RSpec.describe 'SfCli::Sf::Sobject' do
  let(:sobject) { SfCli::Sf::Sobject::Core.new }

  describe '#describe' do
    it "returns the schema infromation of an Object" do
      allow(sobject)
        .to receive(:exec)
        .with(:describe, flags: {:"target-org" => nil, sobject: 'Account', :"api-version" => nil}, redirection: :null_stderr)
        .and_return(exec_output)

      schema = sobject.describe 'Account'

      expect(schema.label).to eq 'Test Custom Object'
      expect(schema.name).to eq 'TestCustomObject__c'

      expect(sobject).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can retrieve a object information in a paticular org, not default one' do
        allow(sobject)
          .to receive(:exec)
          .with(:describe, flags: {:"target-org" => :dev, sobject: 'Account', :"api-version" => nil}, redirection: :null_stderr)
          .and_return(exec_output)

        sobject.describe 'Account', target_org: :dev

        expect(sobject).to have_received :exec
      end
    end

    context 'using option: api_version' do
      it 'can retrieve a object information in a paticular org, not default one' do
        allow(sobject)
          .to receive(:exec)
          .with(:describe, flags: {:"target-org" => nil, sobject: 'Account', :"api-version" => 61.0}, redirection: :null_stderr)
          .and_return(exec_output)

        sobject.describe 'Account', api_version: 61.0

        expect(sobject).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "fields" => [
          {
            "label" => "Custom Object ID",
            "name" => "Id"
          },
          {
            "label" => "Custom Object Name",
            "name" => "Name"
          }
        ],
        "label" => "Test Custom Object",
        "labelPlural" => "Test Custom Object",
        "name" => "TestCustomObject__c"
      },
      "warnings" => []
    }
  end
end
