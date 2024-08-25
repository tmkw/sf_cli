require 'spec_helper'

RSpec.describe 'sf data delete record' do
  let(:sf) { SfCli::Sf.new }
  let(:object_type) { :TestCustomObject__c }
  let(:record_id) { 'some record ID' }

  it "delete a record by record ID" do
    allow(sf).to receive(:`).with(%|sf data delete record --sobject #{object_type} --record-id #{record_id} --json 2> /dev/null|).and_return(command_response)

    sf.data.delete_record object_type, record_id: record_id
    expect(sf).to have_received(:`)
  end

  it "delete a record by search conditions" do
    allow(sf).to receive(:`).with(%|sf data delete record --sobject #{object_type} --where "Name='Akin Kristen'" --json 2> /dev/null|).and_return(command_response)

    sf.data.delete_record object_type, where: {Name: 'Akin Kristen'}
    expect(sf).to have_received(:`)
  end

  it "can delete a record of paticular org, not default one" do
    allow(sf).to receive(:`).with(%|sf data delete record --sobject #{object_type} --record-id #{record_id} --target-org dev --json 2> /dev/null|).and_return(command_response)

    result = sf.data.delete_record object_type, record_id: record_id, target_org: :dev
    expect(sf).to have_received(:`)
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "id": "a00J4000001HkmlIAC",
          "success": true,
          "errors": []
        },
        "warnings": []
      }
    JSON
  end
end
