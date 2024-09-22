RSpec.describe 'sf data upsert resume' do
  let(:job_id) { '750J4000003ebwdIAA' }
  let(:command_line) { "sf data upsert resume --job-id #{job_id} --json 2> /dev/null" }
  let(:command_output) { bulk_result_response }

  before do
    allow_any_instance_of(SfCli::Sf::Data::Core).to receive(:`).with(command_line).and_return(command_output)
  end

  it 'check the result of a upsert job' do
    bulk_result = sf.data.upsert_resume job_id: job_id

    expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(bulk_result.job_info.id).to eq job_id
    expect(bulk_result.job_info).to be_completed
    expect(bulk_result.records.successfulResults).to contain_exactly(
      {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
      {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
    )
    expect(bulk_result.records.failedResults).to be_empty
    expect(bulk_result.records.unprocessedRecords).to be_empty
  end

  context 'with access to paticular org' do
    let(:command_line) { "sf data upsert resume --job-id #{job_id} --target-org dev --json 2> /dev/null" }

    it 'check the result of a upsert job' do
      bulk_result = sf.data.upsert_resume job_id: job_id, target_org: :dev

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty
    end
  end

  context 'using paticular API version' do
    let(:command_line) { "sf data upsert resume --job-id #{job_id} --api-version 61.0 --json 2> /dev/null" }

    it 'check the result of a upsert job' do
      bulk_result = sf.data.upsert_resume job_id: job_id, api_version: 61.0

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty
    end
  end

  context 'with timeout setting' do
    let(:command_line) { "sf data upsert resume --job-id #{job_id} --wait 5 --json 2> /dev/null" }

    it 'waits for the job completed until timeout' do
      bulk_result = sf.data.upsert_resume job_id: job_id, wait: 5

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty
    end
  end

  def bulk_result_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "jobInfo": {
            "id": "#{job_id}",
            "operation": "upsert",
            "object": "TestCustomObject__c",
            "createdById": "0055j00000AUSsWAAX",
            "createdDate": "2024-08-28T00:10:59.000+0000",
            "systemModstamp": "2024-08-28T00:11:01.000+0000",
            "state": "JobComplete",
            "externalIdFieldName": "id",
            "concurrencyMode": "Parallel",
            "contentType": "CSV",
            "apiVersion": 61,
            "jobType": "V2Ingest",
            "lineEnding": "LF",
            "columnDelimiter": "COMMA",
            "numberRecordsProcessed": 2,
            "numberRecordsFailed": 0,
            "retries": 0,
            "totalProcessingTime": 74,
            "apiActiveProcessingTime": 23,
            "apexProcessingTime": 0,
            "isPkChunkingSupported": false
          },
          "records": {
            "successfulResults": [
              {
                "sf__Id": "a00J4000001HkmbIAC",
                "sf__Created": "false",
                "Id": "a00J4000001HkmbIAC",
                "Name": "test custom object 03"
              },
              {
                "sf__Id": "a00J4000001HmEPIA0",
                "sf__Created": "false",
                "Id": "a00J4000001HmEPIA0",
                "Name": "ROMANTIST3"
              }
            ],
            "failedResults": [],
            "unprocessedRecords": []
          }
        },
        "warnings": []
      }
    JSON
  end
end
