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

    def resume(job_id:, target_org: nil)
      flags = {
        :"job-id"     => job_id,
        :"target-org" => target_org,
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)

      json['result'].delete '$'
      JobInfo.new(**json['result'])
    end
  end
end
