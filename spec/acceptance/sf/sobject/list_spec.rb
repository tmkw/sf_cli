require 'spec_helper'

RSpec.describe 'sf sobject list' do
  let(:sf) { SfCli::Sf.new }

  it "returns all object list" do
    allow(sf).to receive(:`).with('sf sobject list --sobject all --json 2> /dev/null').and_return(command_response)

    result = sf.sobject.list :all

    expect(result).to include 'Account'
    expect(result).to include 'TestCustomObject__c'

    expect(sf).to have_received(:`)
  end

  it "returns all custom object list" do
    allow(sf).to receive(:`).with('sf sobject list --sobject custom --json 2> /dev/null').and_return(command_response custom_only: true)

    result = sf.sobject.list :custom

    expect(result).to include 'TestCustomObject__c'
    expect(sf).to have_received(:`)
  end

  it "can get the list of a paticular org, not default one" do
    allow(sf).to receive(:`).with('sf sobject list --sobject all --target-org dev --json 2> /dev/null').and_return(command_response custom_only: true)
    sf.sobject.list :all, target_org: :dev
    expect(sf).to have_received(:`)
  end

  def command_response(custom_only: false)
    <<~JSON
      {
        "status": 0,
        "result": [
          #{custom_only ? '' : '"Account",' }
          "TestCustomObject__c"
        ],
        "warnings": []
      }
    JSON
  end
end
