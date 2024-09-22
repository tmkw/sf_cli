RSpec.describe 'sf data resume' do
  let(:job_id) { "750J4000003fwgnIAA" }

  it 'retrieves a job information' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data resume --job-id #{job_id} --json 2> /dev/null")
      .and_return(job_info_response)

    jobinfo = sf.data.resume job_id: job_id

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::Resume::JobInfo
    expect(jobinfo).to be_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'with accessing to non-default org' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data resume --job-id #{job_id} --target-org dev --json 2> /dev/null")
      .and_return(job_info_response)

    jobinfo = sf.data.resume job_id: job_id, target_org: :dev

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::Resume::JobInfo
    expect(jobinfo).to be_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'using particular API version' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data resume --job-id #{job_id} --api-version 61.0 --json 2> /dev/null")
      .and_return(job_info_response)

    jobinfo = sf.data.resume job_id: job_id, api_version: 61.0

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::Resume::JobInfo
    expect(jobinfo).to be_completed
    expect(jobinfo.id).to eq job_id
  end

  def job_info_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "$": {
            "xmlns": "http://www.force.com/2009/06/asyncapi/dataload"
          },
          "id": "#{job_id}",
          "operation": "query",
          "object": "TestCustomObject__c",
          "createdById": "0055j00000AUSsWAAX",
          "createdDate": "2024-09-07T13:16:04.000Z",
          "systemModstamp": "2024-09-07T13:16:05.000Z",
          "state": "JobComplete",
          "concurrencyMode": "Parallel",
          "contentType": "CSV",
          "numberBatchesQueued": "0",
          "numberBatchesInProgress": "0",
          "numberBatchesCompleted": "2",
          "numberBatchesFailed": "0",
          "numberBatchesTotal": "2",
          "numberRecordsProcessed": "4",
          "numberRetries": "0",
          "apiVersion": "61.0",
          "numberRecordsFailed": "0",
          "totalProcessingTime": "113",
          "apiActiveProcessingTime": "113",
          "apexProcessingTime": "0"
        },
        "warnings": []
      }
    JSON
  end
end
