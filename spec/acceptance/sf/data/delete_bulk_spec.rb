RSpec.describe 'sf data delete bulk' do
  let(:filepath) { 'delete_file.csv'  }
  let(:object_type) { 'Account'  }
  let(:job_id) { '750J4000003ebwdIAA'  }

  it 'starts a delete job' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data delete bulk --file #{filepath} --sobject #{object_type} --json 2> /dev/null")
      .and_return(job_creatation_response)

    jobinfo = sf.data.delete_bulk file: filepath, sobject: object_type

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'with accessing to non-default org' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data delete bulk --file #{filepath} --sobject #{object_type} --target-org dev --json 2> /dev/null")
      .and_return(job_creatation_response)

    jobinfo = sf.data.delete_bulk file: filepath, sobject: object_type, target_org: :dev 

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'start and wait for the delete job' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data delete bulk --file #{filepath} --sobject #{object_type} --wait 5 --json 2> /dev/null")
      .and_return(bulk_result_response)

    bulk_result = sf.data.delete_bulk file: filepath, sobject: object_type, timeout: 5 

    expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(bulk_result.job_info.id).to eq job_id
    expect(bulk_result.job_info).to be_completed
    expect(bulk_result.records.successfulResults).to contain_exactly(
      {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
      {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
    )
  end

  def job_creatation_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "jobInfo": {
            "id": "#{job_id}",
            "operation": "delete",
            "object": "TestCustomObject__c",
            "createdById": "0055j00000AUSsWAAX",
            "createdDate": "2024-08-28T00:10:59.000+0000",
            "systemModstamp": "2024-08-28T00:11:00.000+0000",
            "state": "UploadComplete",
            "externalIdFieldName": "id",
            "concurrencyMode": "Parallel",
            "contentType": "CSV",
            "apiVersion": 61,
            "jobType": "V2Ingest",
            "lineEnding": "LF",
            "columnDelimiter": "COMMA",
            "numberRecordsProcessed": 0,
            "numberRecordsFailed": 0,
            "retries": 0,
            "totalProcessingTime": 0,
            "apiActiveProcessingTime": 0,
            "apexProcessingTime": 0,
            "isPkChunkingSupported": false
          }
        },
        "warnings": []
      }
    JSON
  end

  def bulk_result_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "jobInfo": {
            "id": "#{job_id}",
            "operation": "delete",
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
