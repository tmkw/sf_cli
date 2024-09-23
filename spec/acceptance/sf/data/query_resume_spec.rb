require 'spec_helper'

RSpec.describe 'sf data query resume' do
  let(:job_id) { '750J4000002hj5JIAQ' }

  it 'retrieves records with a job id' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data query resume --bulk-query-id #{job_id} --json 2> /dev/null")
      .and_return(success_response)

    done, rows = sf.data.query_resume job_id: job_id

    expect(done).to be true
    expect(rows).to contain_exactly(
      {'Id' => 'a00J4000001HkmbIAC', 'Name' => 'test custom object 01'},
      {'Id' => 'a00J4000001HmEPIA0', 'Name' => 'ROMANTIST'}
    )
  end

  example 'retrieves from particular org' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data query resume --bulk-query-id #{job_id} --target-org dev --json 2> /dev/null")
      .and_return(success_response)

    sf.data.query_resume job_id: job_id, target_org: :dev
  end

  example 'retrieves by particular API version' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data query resume --bulk-query-id #{job_id} --api-version 61.0 --json 2> /dev/null")
      .and_return(success_response)

    sf.data.query_resume job_id: job_id, api_version: 61.0
  end

  example 'in case of failure because of timeout, etc...' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data query resume --bulk-query-id #{job_id} --json 2> /dev/null")
      .and_return(failure_response)

    done, id = sf.data.query_resume job_id: job_id

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
