require 'spec_helper'

RSpec.describe 'sf sobject describe' do
  it "returns the schema infromation of an Object" do
    allow_any_instance_of(SfCli::Sf::Sobject::Core).to receive(:`).with('sf sobject describe --sobject TestCustomObject__c --json 2> /dev/null').and_return(command_response)

    schema = sf.sobject.describe 'TestCustomObject__c'

    expect(schema.label).to eq 'Test Custom Object'
    expect(schema.name).to eq 'TestCustomObject__c'
  end

  it 'can retrieve a object information in a paticular org, not default one' do
    allow_any_instance_of(SfCli::Sf::Sobject::Core).to receive(:`).with('sf sobject describe --sobject TestCustomObject__c --target-org dev --json 2> /dev/null').and_return(command_response)

    sf.sobject.describe 'TestCustomObject__c', target_org: :dev
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
