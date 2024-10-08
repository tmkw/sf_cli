require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module DeleteBulk
    # Delete records using Bulk API 2.0
    # @param file [String,#read]
    #   (1)path of a CSV file, which is written record IDs to delete.
    #   (2) IO-like object, which has #read method
    # @param sobject     [Symbol, String] object type (ex. Account)
    # @param wait        [Integer]        max minutes to wait for the job complete the task.
    # @param target_org  [Symbol, String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]        override the api version used for api requests made by this command
    #
    # @return [JobInfo, BulkResultV2] the job result, whose type is changed by situation
    #
    # @example
    #   # start a delete job
    #   jobinfo = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv' # this returns immediately
    #   jobinfo.id  # => "750J4000003g1OaIAI" it's job ID
    #
    #   # you can check if the delete job completed
    #   sf.data.delete_resume job_id: jobinfo.id
    #
    #   # Or, you can wait for the job completion with one try.
    #   result = sf.data.delete_bulk sobject: :TestCustomObject__c, file: 'delete.csv', wait: 5  # wait within 5 minutes
    #
    #   # you can use IO-like object, which has #read, to `file` keyword:
    #   require 'stringio'
    #   csv = StringIO.new <<CSV
    #     Id
    #     001J400000Ki61uIAB
    #     001J400000Ki3WRIAZ
    #   CSV
    #   jobinfo = sf.data.delete_bulk sobject: :TestCustomObject__c, file: csv
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_bulk_unified command reference
    #
    #
    def delete_bulk(file:, sobject:, wait: nil, target_org: nil, api_version: nil)
      _file = create_tmpfile_by_io(file)
      path  = _file&.path || file
      flags = {
        :"file"    => path,
        :"sobject"    => sobject,
        :"wait"      => wait,
        :"target-org" => target_org,
        :"api-version" => api_version,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      job_info =  ::SfCli::Sf::Data::JobInfo.new(**json['result']['jobInfo'])
      return job_info unless json['result']['records']

      ::SfCli::Sf::Data::BulkResultV2.new(
        job_info: job_info,
        records:  ::SfCli::Sf::Data::BulkRecordsV2.new(**json['result']['records'])
      )
    ensure
      _file&.close!
    end
  end
end
