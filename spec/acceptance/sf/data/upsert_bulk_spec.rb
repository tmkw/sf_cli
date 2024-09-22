RSpec.describe 'sf data upsert bulk' do
  let(:filepath) { 'upsert_file.csv'  }
  let(:upsert_key_field) { 'Id'  }
  let(:object_type) { 'Account'  }
  let(:job_id) { '750J4000003ebwdIAA'  }

  before do
    allow_any_instance_of(Tempfile).to receive(:path).and_return('sf_tempfile')
  end

  it 'starts a upsert job' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data upsert bulk --file #{filepath} --sobject #{object_type} --external-id #{upsert_key_field} --json 2> /dev/null")
      .and_return(job_creatation_response)

    jobinfo = sf.data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field 

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'Using StringIO instead of path' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data upsert bulk --file sf_tempfile --sobject #{object_type} --external-id #{upsert_key_field} --json 2> /dev/null")
      .and_return(job_creatation_response)

    pseudo_file = StringIO.new <<~EOS
                   Id,Name
                   001J400000Ki61uIAB,foo
                   001J400000Ki69ZIAR,bar
                   001J400000Ki6A9IAJ,baz
                  EOS

    jobinfo = sf.data.upsert_bulk file: pseudo_file, sobject: object_type, external_id: upsert_key_field 

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'with accessing to non-default org' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data upsert bulk --file #{filepath} --sobject #{object_type} --external-id #{upsert_key_field} --target-org dev --json 2> /dev/null")
      .and_return(job_creatation_response)

    jobinfo = sf.data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, target_org: :dev 

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'updates by particular API version' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data upsert bulk --file #{filepath} --sobject #{object_type} --external-id #{upsert_key_field} --api-version 61.0 --json 2> /dev/null")
      .and_return(job_creatation_response)

    jobinfo = sf.data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, api_version: 61.0

    expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
    expect(jobinfo).to be_upload_completed
    expect(jobinfo.id).to eq job_id
  end

  example 'start and wait for the upsert job' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with("sf data upsert bulk --file #{filepath} --sobject #{object_type} --external-id #{upsert_key_field} --wait 5 --json 2> /dev/null")
      .and_return(bulk_result_response)

    bulk_result = sf.data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, wait: 5 

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
            "operation": "upsert",
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
