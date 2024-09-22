require 'spec_helper'

RSpec.describe 'sf data create record' do
  let(:new_record_id) { 'a00J4000001HkmlIAC' }

  it "creates an object record" do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data create record --sobject TestCustomObject__c --values "Name='test custom object'" --json 2> /dev/null|)
      .and_return(command_response)

    record_id = sf.data.create_record :TestCustomObject__c, values: {Name: 'test custom object'}
    expect(record_id).to eq new_record_id
  end

  example "creates an record in the particular org" do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data create record --sobject TestCustomObject__c --values "Name='test custom object'" --target-org dev --json 2> /dev/null|)
      .and_return(command_response)

    record_id = sf.data.create_record :TestCustomObject__c, values: {Name: 'test custom object'}, target_org: :dev
    expect(record_id).to eq new_record_id
  end

  example "creates an record by particular API version" do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data create record --sobject TestCustomObject__c --values "Name='test custom object'" --api-version 61.0 --json 2> /dev/null|)
      .and_return(command_response)

    record_id = sf.data.create_record :TestCustomObject__c, values: {Name: 'test custom object'}, api_version: 61.0
    expect(record_id).to eq new_record_id
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "id": "#{new_record_id}",
          "success": true,
          "errors": []
        },
        "warnings": []
      }
    JSON
  end
end
