require 'spec_helper'

RSpec.describe 'sf data update record' do
  let(:object_type) { :TestCustomObject__c }
  let(:record_id) { 'some record ID' }

  it "updates a record, identifying by record ID" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data update record --sobject #{object_type} --record-id #{record_id} --values "Name='John White' Age=28" --json 2> /dev/null|).and_return(command_response)

    sf.data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
  end

  it "updates a record, identifying by search conditions" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data update record --sobject #{object_type} --where "Name='Alan J Smith' Phone='090-XXXX-XXXX'" --values "Name='John White' Age=28" --json 2> /dev/null|).and_return(command_response)

    sf.data.update_record object_type, where: {Name: 'Alan J Smith', Phone: '090-XXXX-XXXX'}, values: {Name: 'John White', Age: 28}
  end

  it "can update a record of paticular org, not default one" do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(%|sf data update record --sobject #{object_type} --record-id #{record_id} --values "Name='John White' Age=28" --target-org dev --json 2> /dev/null|).and_return(command_response)

    sf.data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, target_org: :dev
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "id": "#{record_id}",
          "success": true,
          "errors": []
        },
        "warnings": []
      }
    JSON
  end
end
