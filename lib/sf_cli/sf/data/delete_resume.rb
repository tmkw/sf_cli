require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module DeleteResume
    # resume a bulk delete job you previously started with Bulk API 2.0 and return a bulk result object.
    #
    # *job_id* ---  job ID you want to resume<br>
    #
    # *timeout* --- max minutes to wait for the job complete the task.<br>
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # ======
    #   # start a delete job
    #   jobinfo = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv' # this returns immediately
    #   jobinfo.id  # => "750J4000003g1OaIAI" it's job ID
    #
    #   # the job has already started asynchronously.
    #   # So you should check its progress.
    #   # if you want to wait for the job complete the task, try 'timeout' option.
    #   result = sf.data.delete_resume job_id: jobinfo.id
    #
    #   puts 'yey!' if result.job_info.completed? # the job has completed
    #
    # To know more about a job result, take a look at SfCli::Sf::Data module
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_resume_unified]
    #
    def delete_resume(job_id:, timeout: nil, target_org: nil)
      flags = {
        :"job-id"     => job_id,
        :"wait"       => timeout,
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
