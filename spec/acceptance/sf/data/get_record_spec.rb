require 'spec_helper'

RSpec.describe 'sf data get record' do
  let(:sf) { SfCli::Sf.new }
  let(:object_type) { :TestCustomObject__c }
  let(:record_id) { 'some record ID' }

  it "gets a record by record ID" do
    allow(sf).to receive(:`).with(%|sf data get record --sobject #{object_type} --record-id #{record_id} --json 2> /dev/null|).and_return(command_response)

    result = sf.data.get_record object_type, record_id: record_id

    expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
    expect(sf).to have_received(:`)
  end

  it "gets a record by search conditions" do
    allow(sf).to receive(:`).with(%|sf data get record --sobject #{object_type} --where "Name='Akin Kristen'" --json 2> /dev/null|).and_return(command_response)

    result = sf.data.get_record object_type, where: {Name: 'Akin Kristen'}

    expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
    expect(sf).to have_received(:`)
  end

  it "gets and converts a record into the model object" do
    allow(sf).to receive(:`).with(%|sf data get record --sobject #{object_type} --record-id #{record_id} --json 2> /dev/null|).and_return(command_response)

    TestCustomObject__c = Struct.new(:Id, :Name)
    object = sf.data.get_record object_type, record_id: record_id, model_class: TestCustomObject__c

    expect(object).to have_attributes Id: record_id, Name: 'Akin Kristen'
    expect(sf).to have_received(:`)
  end

  it "can gets a record of paticular org, not default one" do
    allow(sf).to receive(:`).with(%|sf data get record --sobject #{object_type} --record-id #{record_id} --target-org dev --json 2> /dev/null|).and_return(command_response)

    result = sf.data.get_record object_type, record_id: record_id, target_org: :dev

    expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
    expect(sf).to have_received(:`)
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "attributes": {
            "type": "TestCustomObject__c",
            "url": "/services/data/v61.0/sobjects/TestCustomObject__c/0035j00001RW3xbAAD"
          },
          "Id": "#{record_id}",
          "Name": "Akin Kristen"
        },
        "warnings": []
      }
    JSON
  end
end