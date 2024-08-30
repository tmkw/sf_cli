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

  context 'in case of multi sobject query:' do
    it "returns the combined sobject result" do
      allow(sf).to receive(:`).with('sf data query --query "SELECT Id, Name, Account.Name, (SELECT Name FROM Contacts) FROM Hoge__c Limit 1" --json 2> /dev/null').and_return(exec_output_by_multi_sobject_query)

      rows = sf.data.query %|SELECT Id, Name, Account.Name, (SELECT Name FROM Contacts) FROM Hoge__c Limit 1|

      expect(rows).to contain_exactly({
        'Id' => "0015j00001dsDuhAAE",
        'Name' => "Hoge Baz Bar!",
        'Account' => {'Name' => "Aethna Home Products"},
        'Contacts' => [
          {'Name' => "Akin Kristen"},
          {'Name' => "Akin Kristen2"}
        ]
      }, {
        'Id' => "0015j00001U2XvOAAV",
        'Name' => "Hoge FugaBaz",
        'Account' => {'Name' => "Aethna Home Products2"},
        'Contacts' => [
          {'Name' => "Frank Edna", 'Foo' => {'Name' => "Foo Fighters"}},
        ]
      })

      expect(sf).to have_received(:`)
    end
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

  def exec_output_by_multi_sobject_query
    <<~JSON
      {
        "status": 0,
        "result": {
          "records": [
            {
              "attributes": {
                "type": "Hoge__c",
                "url": "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
              },
              "Id": "0015j00001dsDuhAAE",
              "Name": "Hoge Baz Bar!",
              "Account": {
                "attributes": {
                  "type": "Account",
                  "url": "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
                },
                "Name": "Aethna Home Products"
              },
              "Contacts": {
                "totalSize": 2,
                "done": true,
                "records": [
                  {
                    "attributes": {
                      "type": "Contact",
                      "url": "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
                    },
                    "Name": "Akin Kristen"
                  },
                  {
                    "attributes": {
                      "type": "Contact",
                      "url": "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
                    },
                    "Name": "Akin Kristen2"
                  }
                ]
              }
            },
            {
              "attributes": {
                "type": "Hoge__c",
                "url": "/services/data/v61.0/sobjects/Account/0015j00001U2XvOAAV"
              },
              "Id": "0015j00001U2XvOAAV",
              "Name": "Hoge FugaBaz",
              "Account": {
                "attributes": {
                  "type": "Account",
                  "url": "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
                },
                "Name": "Aethna Home Products2"
              },
              "Contacts": {
                "totalSize": 1,
                "done": true,
                "records": [
                  {
                    "attributes": {
                      "type": "Contact",
                      "url": "/services/data/v61.0/sobjects/Contact/0035j00001HB84MAAT"
                    },
                    "Name": "Frank Edna",
                    "Foo": {
                      "attributes": {
                        "type": "Foo",
                        "url": "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
                      },
                      "Name": "Foo Fighters"
                    }
                  }
                ]
              }
            }
          ],
          "totalSize": 2,
          "done": true
        },
        "warnings": []
      }
    JSON
  end
end
