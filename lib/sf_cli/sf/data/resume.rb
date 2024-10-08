module SfCli::Sf::Data
  module Resume
    JobInfo = Struct.new(
      :id,
      :operation,
      :object,
      :createdById,
      :createdDate,
      :systemModstamp,
      :state,
      :concurrencyMode,
      :contentType,
      :numberBatchesQueued,
      :numberBatchesInProgress,
      :numberBatchesCompleted,
      :numberBatchesFailed,
      :numberBatchesTotal,
      :numberRecordsProcessed,
      :numberRetries,
      :apiVersion,
      :numberRecordsFailed,
      :totalProcessingTime,
      :apiActiveProcessingTime,
      :apexProcessingTime
    ) do
      def opened?
        state == 'Open'
      end

      def upload_completed?
        state == 'UploadComplete'
      end

      def in_progress?
        state == 'InProgress'
      end

      def completed?
        state == 'JobComplete'
      end

      def failed?
        state == 'Failed'
      end

      def aborted?
        state == 'Aborted'
      end
    end

    # View the status of a bulk job.
    # @param job_id      [String]        job ID you want to resume
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    #
    # @return [JobInfo] job information
    #
    # @example
    #   # start a delete job
    #   jobinfo = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv' # this returns immediately
    #   jobinfo.id  # => "750J4000003g1OaIAI" it's job ID
    #
    #   jobinfo2 = sf.data.resume job_id: jobinfo.id
    #
    #   puts 'yey!' if job_info2.completed? # the job has completed
    #
    # The job info object has methods to check the job status:
    # - opened?
    # - upload_completed?
    # - in_progress?
    # - completed?
    #
    # To know job status more, take a look at {https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/bulk_api_2_job_states.htm the bulk API developer guide}
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_resume_unified command reference
    #
    def resume(job_id:, target_org: nil, api_version: nil)
      flags = {
        :"job-id"     => job_id,
        :"target-org" => target_org,
        :"api-version" => api_version,
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)

      json['result'].delete '$'
      JobInfo.new(**json['result'])
    end
  end
end
