require_relative './helper_methods'
require_relative './query_helper'

module SfCli::Sf::Data
  module Query
    # get object records using SQOL. (eqivalent to *sf* *data* *query*)
    #
    # *soql* --- SOQL<br>
    # *target_org* --- an alias of paticular org, not default one<br>
    # *model_class* --- the object model class<br>
    #
    # == examples
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
    #   Account = Struct.new(:Id, :Name) # you can manually prepare the object model
    #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account
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
      format = format || :json

      result = exec(__method__, flags: flags, switches: switches, redirection: :null_stderr, raw_output: raw_output, format: format)

      return_result(result, raw_output, bulk, model_class)
    end

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
