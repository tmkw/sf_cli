require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module DeleteResume
    # Resume a bulk delete job you previously started with Bulk API 2.0 and return a bulk result object.
    #
    # @param job_id     [String]         job ID you want to resume<br>
    # @param wait    [Integer]        max minutes to wait for the job complete the task.<br>
    # @param target_org [Symbol, String] an alias of paticular org, or username can be used<br>
    #
    # @return [JobInfo, BulkResultV2] the job result, whose type is changed by situation
    #
    # @example
    #   # start a delete job
    #   jobinfo = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv' # this returns immediately
    #   jobinfo.id  # => "750J4000003g1OaIAI" it's job ID
    #
    #   # the job has already started asynchronously.
    #   # So you should check its progress.
    #   # if you want to wait for the job complete the task, try 'wait' option.
    #   result = sf.data.delete_resume job_id: jobinfo.id
    #
    #   puts 'yey!' if result.job_info.completed? # the job has completed
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_resume_unified the command reference
    #
    def delete_resume(job_id:, wait: nil, target_org: nil)
      flags = {
        :"job-id"     => job_id,
        :"wait"       => wait,
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      job_info =  ::SfCli::Sf::Data::JobInfo.new(**json['result']['jobInfo'])
      return job_info unless json['result']['records']

      ::SfCli::Sf::Data::BulkResultV2.new(
        job_info: job_info,
        records:  ::SfCli::Sf::Data::BulkRecordsV2.new(**json['result']['records'])
      )
    end
  end
end
