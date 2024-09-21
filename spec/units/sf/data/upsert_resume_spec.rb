RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#upsert_resume'do
    let(:job_id) { '750J4000003ebwdIAA' }

    it 'check the result of a upsert job' do
      allow(data).to receive(:exec).with(
        'upsert resume',
        flags: {
          :"job-id" => job_id,
          :"target-org" => nil,
          :"wait" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(bulk_result_response)

      bulk_result = data.upsert_resume job_id: job_id

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty

      expect(data).to have_received :exec
    end

    example 'with accessing to non-default org' do
      allow(data).to receive(:exec).with(
        'upsert resume',
        flags: {
          :"job-id" => job_id,
          :"target-org" => :dev,
          :"wait" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(bulk_result_response)

      bulk_result = data.upsert_resume job_id: job_id, target_org: :dev

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty

      expect(data).to have_received :exec
    end

    example 'setting timeout' do
      allow(data).to receive(:exec).with(
        'upsert resume',
        flags: {
          :"job-id" => job_id,
          :"target-org" => nil,
          :"wait" => 5,
        },
        redirection: :null_stderr
      )
      .and_return(bulk_result_response)

      bulk_result = data.upsert_resume job_id: job_id, wait: 5

      expect(bulk_result.job_info).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(bulk_result.job_info.id).to eq job_id
      expect(bulk_result.job_info).to be_completed
      expect(bulk_result.records.successfulResults).to contain_exactly(
        {"sf__Id" => "a00J4000001HkmbIAC", "sf__Created" => "false", "Id" => "a00J4000001HkmbIAC", "Name" => "test custom object 03"},
        {"sf__Id" => "a00J4000001HmEPIA0", "sf__Created" => "false", "Id" => "a00J4000001HmEPIA0", "Name" => "ROMANTIST3"}
      )
      expect(bulk_result.records.failedResults).to be_empty
      expect(bulk_result.records.unprocessedRecords).to be_empty

      expect(data).to have_received :exec
    end
  end

  def bulk_result_response
    {
      "status" => 0,
      "result" => {
        "jobInfo" => {
          "id" => "#{job_id}",
          "operation" => "upsert",
          "object" => "TestCustomObject__c",
          "createdById" => "0055j00000AUSsWAAX",
          "createdDate" => "2024-08-28T00:10:59.000+0000",
          "systemModstamp" => "2024-08-28T00:11:01.000+0000",
          "state" => "JobComplete",
          "externalIdFieldName" => "id",
          "concurrencyMode" => "Parallel",
          "contentType" => "CSV",
          "apiVersion" => 61,
          "jobType" => "V2Ingest",
          "lineEnding" => "LF",
          "columnDelimiter" => "COMMA",
          "numberRecordsProcessed" => 2,
          "numberRecordsFailed" => 0,
          "retries" => 0,
          "totalProcessingTime" => 74,
          "apiActiveProcessingTime" => 23,
          "apexProcessingTime" => 0,
          "isPkChunkingSupported" => false
        },
        "records" => {
          "successfulResults" => [
            {
              "sf__Id" => "a00J4000001HkmbIAC",
              "sf__Created" => "false",
              "Id" => "a00J4000001HkmbIAC",
              "Name" => "test custom object 03"
            },
            {
              "sf__Id" => "a00J4000001HmEPIA0",
              "sf__Created" => "false",
              "Id" => "a00J4000001HmEPIA0",
              "Name" => "ROMANTIST3"
            }
          ],
          "failedResults" => [],
          "unprocessedRecords" => []
        }
      },
      "warnings" => []
    }
  end
end
