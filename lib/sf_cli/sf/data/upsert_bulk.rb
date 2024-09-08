require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module UpsertBulk
    # update records using Bulk API 2.0
    #
    # *file* --- a \CSV file for update records<br>
    #
    # *sobject* --- \Object Type (ex. Account)<br>
    #
    # *external_id* --- Name of the external ID field, or the Id field<br>
    #
    # *timeout* --- max minutes to wait for the job complete the task.<br>
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # ======
    #   # start a upsert job
    #   jobinfo = sf.data.upsert_bulk sobject: :TestCustomObject__c, file: 'upsert.csv' # this returns immediately
    #   jobinfo.id  # => "750J4000003g1OaIAI" it's job ID
    #
    #   # you can check if the upsert job completed
    #   sf.data.upsert_resume job_id: jobinfo.id
    #
    #   # Or, you can wait for the job completion with one try.
    #   result = sf.data.upsert_bulk sobject: :TestCustomObject__c, file: 'upsert.csv', timeout: 5  # wait within 5 minutes
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_upsert_bulk_unified]
    #
    def upsert_bulk(file:, sobject:, external_id:, timeout: nil, target_org: nil)
      flags = {
        :"file"    => file,
        :"sobject"    => sobject,
        :"external-id"  => external_id,
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
