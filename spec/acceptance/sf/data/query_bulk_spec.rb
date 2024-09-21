require 'spec_helper'

RSpec.describe 'sf data query' do
  let(:job_id) { '750J4000002hj5JIAQ' }

  it "queries with SOQL,  using bulk API (default wait: 1 minute)" do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --json --bulk 2> /dev/null')
      .and_return(success_response)

    done, rows = sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|, bulk: true

    expect(done).to be true
    expect(rows).to contain_exactly(
      {'Id' => 'a00J4000001HkmbIAC', 'Name' => 'test custom object 01'},
      {'Id' => 'a00J4000001HmEPIA0', 'Name' => 'ROMANTIST'}
    )
  end

  example 'manual setting timeout (unit: minute)' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --wait 3 --json --bulk 2> /dev/null')
      .and_return(success_response)

    done, rows = sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|, bulk: true, wait: 3
  end

  example 'in case of failure because of timeout, etc...' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with('sf data query --query "SELECT Id, Name FROM Account LIMIT 1" --json --bulk 2> /dev/null')
      .and_return(failure_response)

    done, id = sf.data.query %|SELECT Id, Name FROM Account LIMIT 1|, bulk: true

    expect(done).to be false
    expect(id).to eq job_id
  end

  def success_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "done": true,
          "records": [
            {
              "Id": "a00J4000001HkmbIAC",
              "Name": "test custom object 01"
            },
            {
              "Id": "a00J4000001HmEPIA0",
              "Name": "ROMANTIST"
            }
          ],
          "totalSize": 2
        },
        "warnings": []
      }
    JSON
  end

  def failure_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "done": false,
          "records": [],
          "totalSize": 0,
          "id": "#{job_id}"
        }
      }
    JSON
  end
end
