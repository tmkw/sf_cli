require 'spec_helper'

RSpec.describe 'sf sobject describe' do
  let(:sf) { SfCli::Sf.new }

  it "returns the schema infromation of an Object" do
    allow(sf).to receive(:`).with('sf sobject describe --sobject TestCustomObject__c --json 2> /dev/null').and_return(command_response)

    result = sf.sobject.describe 'TestCustomObject__c'

    expect(result['label']).to eq 'Test Custom Object'
    expect(result['name']).to eq 'TestCustomObject__c'

    expect(sf).to have_received(:`)
  end

  it 'can retrieve a object information in a paticular org, not default one' do
    allow(sf).to receive(:`).with('sf sobject describe --sobject TestCustomObject__c --target-org dev --json 2> /dev/null').and_return(command_response)

    sf.sobject.describe 'TestCustomObject__c', target_org: :dev
    expect(sf).to have_received(:`)
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "fields": [
            {
              "label": "Custom Object ID",
              "name": "Id"
            },
            {
              "label": "Custom Object Name",
              "name": "Name"
            }
          ],
          "label": "Test Custom Object",
          "labelPlural": "Test Custom Object",
          "name": "TestCustomObject__c"
        },
        "warnings": []
      }
    JSON
  end
end
