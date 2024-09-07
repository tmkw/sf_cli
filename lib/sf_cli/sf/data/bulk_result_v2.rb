module SfCli
  module Sf
    module Data
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

      BulkRecordsV2 = Struct.new(:successfulResults, :failedResults, :unprocessedRecords)

      BulkResultV2 = Struct.new(:job_info, :records)
    end
  end
end
