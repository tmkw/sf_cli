require 'json'
require_relative './base'

module SfCli
  class Sf
    # ==== description
    # The class representing *sf* *sobject*
    #
    # command reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm
    #
    class SObject < Base

      # get the schema information of a Salesforce object and returns a hash object. It's equivalent to use *sf* *sobject* *describe*
      #
      # *objectType* --- object type (ex: Account)
      #
      def describe(objectType)
        json = JSON.parse `sf sobject describe --json --sobject #{objectType} #{flag :"target-org", target_org}  #{null_stderr_redirection}`
        raise StandardError.new(%|sf sobject describe: failed. (sobject: #{objectType})|) if json['status'] != 0

        json['result']
      end

      # returns a list of Salesforce object name (object's API name). It's equivalent to *sf* *sobject* *list*
      #
      # *object_type* --- all or custom (default: all)
      #
      def list(object_type: 'all')
        json = JSON.parse `sf sobject list --json --sobject #{object_type} #{flag :"target-org", target_org} #{null_stderr_redirection}`
        raise StandardError.new(%|sf sobject list: failed.|) if json['status'] != 0

        json['result']
      end
    end
  end
end
