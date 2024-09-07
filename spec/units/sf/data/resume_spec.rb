RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#resume'do
    let(:job_id) { '750J4000003ebwdIAA' }

    it 'retrieves a job information' do
      allow(data).to receive(:exec).with(
        :resume,
        flags: {
          :"job-id" => job_id,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(job_info_response)

      jobinfo = data.resume job_id: job_id

      expect(jobinfo).to be_instance_of SfCli::Sf::Data::Resume::JobInfo
      expect(jobinfo).to be_completed
      expect(jobinfo.id).to eq job_id

      expect(data).to have_received :exec
    end

    example 'with accessing to non-default org' do
      allow(data).to receive(:exec).with(
        :resume,
        flags: {
          :"job-id" => job_id,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(job_info_response)

      jobinfo = data.resume job_id: job_id

      expect(jobinfo).to be_instance_of SfCli::Sf::Data::Resume::JobInfo
      expect(jobinfo).to be_completed
      expect(jobinfo.id).to eq job_id

      expect(data).to have_received :exec
    end
  end

  def job_info_response
    {
      "status" => 0,
      "result" => {
        "$" => {
          "xmlns": "http://www.force.com/2009/06/asyncapi/dataload"
        },
        "id" => "#{job_id}",
        "operation" => "query",
        "object" => "TestCustomObject__c",
        "createdById" => "0055j00000AUSsWAAX",
        "createdDate" => "2024-09-07T13:16:04.000Z",
        "systemModstamp" => "2024-09-07T13:16:05.000Z",
        "state" => "JobComplete",
        "concurrencyMode" => "Parallel",
        "contentType" => "CSV",
        "numberBatchesQueued" => "0",
        "numberBatchesInProgress" => "0",
        "numberBatchesCompleted" => "2",
        "numberBatchesFailed" => "0",
        "numberBatchesTotal" => "2",
        "numberRecordsProcessed" => "4",
        "numberRetries" => "0",
        "apiVersion" => "61.0",
        "numberRecordsFailed" => "0",
        "totalProcessingTime" => "113",
        "apiActiveProcessingTime" => "113",
        "apexProcessingTime" => "0"
      },
      "warnings" => []
    }
  end
end
