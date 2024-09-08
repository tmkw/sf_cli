require_relative './helper_methods'
require_relative './query_helper'

module SfCli::Sf::Data
  module Query
    # get object records using SOQL.
    #
    # *soql* --- SOQL<br>
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # *format* --- get the command's raw output. human, csv, json can be available<br>
    #
    # *model_class* --- the object model class<br>
    #
    # *bulk* --- use Bulk API<br>
    #
    # *timeout* --- max minutes to wait for the job complete in Bulk API mode<br>
    #
    # ======
    #   sf.data.query 'SELECT Id, Name FROM Account LIMIT 1' # => [{Id: "abc", Name: "account name"}]
    #
    #   Account = Struct.new(:Id, :Name)
    #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account struct object
    #
    #   # child-parent relationship is supported
    #   sf.data.query 'SELECT Id, Name, Account.Name From Contact Limit 1'  #  [{Id: "abc", Name: "contact name", Account: {Name: "account name"}}]
    #
    #   # parent-children relationship is supported
    #   sf.data.query 'SELECT Id, Name, (SELECT Name From Contacts) FROM Account Limit 1'  #  [{Id: "abc", Name: "account name", Contacts: [{Name: "contact name"}]}]
    #
    # When using Bulk API, you get the records when the query job completes within time limit.
    # The method returns a tapple(an array), which changes its contents according to the job result.
    #
    # ======
    #   done, result = sf.data.query 'SELECT Id, Name FROM Account', bulk: true              # max wait 1 min to get result (default)
    #   done, result = sf.data.query 'SELECT Id, Name FROM Account', bulk: true, timeout: 5  # max wait 5 min to get result
    #   done, result = sf.data.query 'SELECT Id, Name FROM Account', bulk: true, timeout: 0  # returns immediately
    #
    #   rows = result   if done     # if job is completed, the result is an array of record
    #   job_id = result unless done # if job hasn't completed or it has aborted, the result is the job ID
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_query_unified]
    #
    # About querying with auto generated object model, see the section {"Object Model support"}[link://files/README_rdoc.html#label-Object+Model+support+-28experimental-2C+since+0.0.4-29] in README.
    #
    def query(soql, target_org: nil, format: nil, bulk: false, timeout: nil, model_class: nil)
      flags    = {
        :"query"    => %("#{soql}"),
        :"target-org" => target_org,
        :"result-format" => format,
        :"wait" => (bulk ? timeout : nil),
      }
      switches = {
        bulk: bulk,
      }
      raw_output = format ? true : false
      format = format&.to_sym || :json

      result = exec(__method__, flags: flags, switches: switches, redirection: :null_stderr, raw_output: raw_output, format: format)

      return_result(result, raw_output, bulk, model_class)
    end

    # resume a bulk query job, which you previously started, and get records
    #
    # *job_id* ---  job ID you want to resume<br>
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # *format* --- get the command's raw output. human, csv, json can be available<br>
    #
    # *model_class* --- the object model class<br>
    #
    # ======
    #   # start a query job
    #   result1 = sf.data.query 'SELECT Id, Name FROM Account', bulk: true, timeout: 0  # returns immediately
    #
    #   result1 # => [false, "<job id>"]
    #
    #   # the job has already started asynchronously.
    #   # So you should check and get the result.
    #   done, result2 = sf.data.query_resume job_id: result1.last
    #
    #   puts 'get the records!' if done # the job has completed
    #
    #   result2 # => if done is true, this is an array of record. Otherwise it should be the Job ID.
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_query_resume_unified]
    def query_resume(job_id:, target_org: nil, format: nil, model_class: nil)
      flags    = {
        :"bulk-query-id" => job_id,
        :"target-org" => target_org,
        :"result-format" => format,
      }
      raw_output = format ? true : false
      format = format || :json

      action = __method__.to_s.tr('_', ' ')
      result = exec(action, flags: flags, redirection: :null_stderr, raw_output: raw_output, format: format)

      return_result(result, raw_output, true, model_class)
    end

    def return_result(result, raw_output, bulk, model_class)
      result_adjuster = 
        if raw_output
          RawOutputResultAdjuster.new(result)
        elsif bulk
          BulkResultAdjuster.new(result, model_class)
        else
          RegularResultAdjuster.new(result, model_class)
        end

      result_adjuster.get_return_value
    end

    private :return_result
  end
end
