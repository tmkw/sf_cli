require 'spec_helper'

RSpec.describe 'sf data query', :model do
  let(:sf) { SfCli::Sf.new }

  it "queries with SOQL" do
    allow(sf).to receive(:`).with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --json 2> /dev/null').and_return(command_response)

    rows = sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|

    expect(rows).to contain_exactly({'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"})
    expect(sf).to have_received(:`)
  end

  it "can convert each record into a paticular model object" do
    allow(sf).to receive(:`).with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --json 2> /dev/null').and_return(command_response)

    rows = sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|, model_class: Account

    expect(rows).to contain_exactly( an_object_having_attributes('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"))
    expect(rows.first).to be_instance_of Account
  end

  it 'can query againt a paticular org, not default one' do
    allow(sf).to receive(:`).with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --target-org dev --json 2> /dev/null').and_return(command_response)

    sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|, target_org: :dev
    expect(sf).to have_received(:`)
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "records": [
            {
              "attributes": {
                "type": "Account",
                "url": "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
              },
              "Id": "0015j00001dsDuhAAE",
              "Name": "Aethna Home Products"
            }
          ],
          "totalSize": 1,
          "done": true
        },
        "warnings": []
      }
    JSON
  end
end
