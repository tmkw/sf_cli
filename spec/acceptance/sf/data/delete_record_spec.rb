require 'spec_helper'

RSpec.describe 'sf data delete record' do
  let(:object_type) { :TestCustomObject__c }
  let(:record_id) { 'some record ID' }

  it "deletes a record by record ID" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data delete record --sobject #{object_type} --record-id #{record_id} --json 2> /dev/null|).and_return(command_response)

    sf.data.delete_record object_type, record_id: record_id
  end

  example "deletes by search conditions" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data delete record --sobject #{object_type} --where "Name='Akin Kristen'" --json 2> /dev/null|).and_return(command_response)

    sf.data.delete_record object_type, where: {Name: 'Akin Kristen'}
  end

  example "delete a record of paticular org" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data delete record --sobject #{object_type} --record-id #{record_id} --target-org dev --json 2> /dev/null|).and_return(command_response)

    result = sf.data.delete_record object_type, record_id: record_id, target_org: :dev
  end

  example "delete by paticular API version" do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data delete record --sobject #{object_type} --record-id #{record_id} --api-version 61.0 --json 2> /dev/null|)
      .and_return(command_response)

    result = sf.data.delete_record object_type, record_id: record_id, api_version: 61.0
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
