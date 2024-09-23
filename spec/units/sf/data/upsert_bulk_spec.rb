RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#upsert_bulk'do
    let(:filepath) { 'upsert_file.csv'  }
    let(:upsert_key_field) { 'Id'  }
    let(:object_type) { 'Account'  }
    let(:job_id) { '750J4000003ebwdIAA' }
    let(:target_org) { nil }
    let(:api_version) { nil }
    let(:time_limit) { nil }
    let(:output) { job_creatation_response }

    before do
      allow(data).to receive(:exec).with(
        'upsert bulk',
        flags: {
          file:    filepath,
          sobject: object_type,
          :"external-id" => upsert_key_field,
          :"target-org"  => target_org,
          :"wait"  => time_limit,
          :"api-version"  => api_version,
        },
        redirection: :null_stderr
      )
      .and_return(output)
    end

    it 'starts a upsert job' do
      jobinfo = data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field 

      expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
      expect(jobinfo).to be_upload_completed
      expect(jobinfo.id).to eq job_id

      expect(data).to have_received :exec
    end

    context 'Using StringIO instead of file path' do
      let(:filepath) { '/tmp/file' }
      let(:tempfile) { instance_double('Tempfile') }
      let(:string_io) { instance_double('StringIO', read: 'csv contents') }

      before do
        allow(data).to receive(:create_tmpfile_by_io).with(string_io).and_return(tempfile)
        allow(tempfile).to receive(:path).and_return(filepath)
        allow(tempfile).to receive(:close!)
      end

      it 'starts a upsert job' do
        jobinfo = data.upsert_bulk file: string_io, sobject: object_type, external_id: upsert_key_field 

        expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo
        expect(jobinfo).to be_upload_completed
        expect(jobinfo.id).to eq job_id

        expect(data).to have_received :exec
        expect(data).to have_received :create_tmpfile_by_io
        expect(tempfile).to have_received :path
        expect(tempfile).to have_received :close!
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it 'starts a job of particular org' do
        jobinfo = data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, target_org: target_org
        expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo

        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'starts a job of particular org' do
        jobinfo = data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, api_version: api_version
        expect(jobinfo).to be_instance_of SfCli::Sf::Data::JobInfo

        expect(data).to have_received :exec
      end
    end

    context 'using option: wait' do
      let(:time_limit) { 5 } # 5 min
      let(:output) { bulk_result_response }

      it 'waits for job completed' do
        bulk_result = data.upsert_bulk file: filepath, sobject: object_type, external_id: upsert_key_field, wait: 5

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
  end

  def job_creatation_response
    {
      "status" => 0,
      "result" => {
        "jobInfo" => {
          "id" => "#{job_id}",
          "operation" => "upsert",
          "object" => "TestCustomObject__c",
          "createdById" => "0055j00000AUSsWAAX",
          "createdDate" => "2024-08-28T00:10:59.000+0000",
          "systemModstamp" => "2024-08-28T00:11:00.000+0000",
          "state" => "UploadComplete",
          "externalIdFieldName" => "id",
          "concurrencyMode" => "Parallel",
          "contentType" => "CSV",
          "apiVersion" => 61,
          "jobType" => "V2Ingest",
          "lineEnding" => "LF",
          "columnDelimiter" => "COMMA",
          "numberRecordsProcessed" => 0,
          "numberRecordsFailed" => 0,
          "retries" => 0,
          "totalProcessingTime" => 0,
          "apiActiveProcessingTime" => 0,
          "apexProcessingTime" => 0,
          "isPkChunkingSupported" => false
        }
      },
      "warnings": []
    }
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
