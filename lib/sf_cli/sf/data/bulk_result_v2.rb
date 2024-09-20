module SfCli
  module Sf
    module Data
      # Bulk Job information.
      #
      # You can check the job status using the following method:
      # - opened?
      # - upload_completed?
      # - in_progress?
      # - completed?
      # @example
      #   result = sf.data.delete_resume job_id: jobinfo.id
      #   puts 'yey!' if result.job_info.completed? # the job has completed
      #
      # See Also: {https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/bulk_api_2_job_states.htm the guide document}
      #
      JobInfo = Struct.new(
        :id,
        :operation,
        :object,
        :createdById,
        :createdDate,
        :systemModstamp,
        :state,
        :externalIdFieldName,
        :concurrencyMode,
        :contentType,
        :apiVersion,
        :jobType,
        :lineEnding,
        :columnDelimiter,
        :numberRecordsProcessed,
        :numberRecordsFailed,
        :retries,
        :totalProcessingTime,
        :apiActiveProcessingTime,
        :apexProcessingTime,
        :isPkChunkingSupported
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

      #
      # Records processed by Bulk API
      #
      BulkRecordsV2 = Struct.new(:successfulResults, :failedResults, :unprocessedRecords)

      #
      # Bulk Result information that contains JobInfo and BulkRecordsV2
      #
      BulkResultV2 = Struct.new(:job_info, :records)
    end
  end
end
