require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module DeleteBulk
    # delete records using Bulk API 2.0
    #
    # *file* --- a CSV file, which is written record IDs to delete<br>
    #
    # *sobject* --- \Object Type (ex. Account)<br>
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
    #   # you can check if the delete job completed
    #   sf.data.delete_resume job_id: jobinfo.id
    #
    #   # Or, you can wait for the job completion with one try.
    #   result = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv', timeout: 5  # wait within 5 minutes
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_bulk_unified]
    #
    def delete_bulk(file:, sobject:, timeout: nil, target_org: nil)
      flags = {
        :"file"    => file,
        :"sobject"    => sobject,
        :"wait"      => timeout,
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
