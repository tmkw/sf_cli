RSpec.describe 'SfCli::Sf::Sobject' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:sobject) { SfCli::Sf::Sobject.new(sf) }

  describe '#describe' do
    it "returns the schema infromation of an Object" do
      allow(sf).to receive(:exec).with('sobject', :describe, flags: {:"target-org" => nil, sobject: 'Account'}, switches: {}, redirection: :null_stderr).and_return(describe_response)

      schema = sobject.describe 'Account'

      expect(schema['label']).to eq 'Test Custom Object'
      expect(schema['name']).to eq 'TestCustomObject__c'

      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
    it 'can retrieve a object information in a paticular org, not default one' do
        allow(sf).to receive(:exec).with('sobject', :describe, flags: {:"target-org" => :dev, sobject: 'Account'}, switches: {}, redirection: :null_stderr).and_return(describe_response)
        sobject.describe 'Account', target_org: :dev

        expect(sf).to have_received :exec
      end
    end
  end

  def describe_response
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
