require 'json'
require_relative './base'

module SfCli
  class Sf
    #
    # ==== description
    # The class representing *sf* *data*
    #
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm
    #
    class Data < Base

      # get the object records. It's eqivalent to use *sf* *data* *query*
      #
      # *soql* --- SOQL
      #
      # *model_class* --- the data model class representing the record object.  
      #
      # ==== examples
      #   sf.data.query('SELECT Id, Name From Account Limit 3') # returns an array of Hash object
      #
      #   Account = Struct.new(:Id, :Name)
      #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account struct object
      #
      def query(soql, model_class: nil)
        json = JSON.parse `sf data query --json --query "#{soql}" #{flag :"target-org", target_org} #{null_stderr_redirection}`
        raise StandardError.new(%|sf data query: failed. (query: "#{soql}")|) if json['status'] != 0

        json['result']['records'].each_with_object([]) do |h, a|
          h.delete "attributes"
          a << (model_class ? model_class.new(**h) : h)
        end
      end
    end
  end
end

