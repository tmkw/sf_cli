require_relative '../core/base'

module SfCli
  module Sf
    module Sobject
      # ==== description
      # The class representing *sf* *sobject*
      #
      # command reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base

        # returns a hash object containing the Salesforce object schema
        #
        # *objectType* --- object type (ex: Account)<br>
        #
        # *target_org* --- an alias of paticular org, or username can be used<br>
        #
        # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm#cli_reference_sobject_describe_unified]
        #
        def describe(object_type, target_org: nil)
          flags    = {
            :"sobject"    => object_type,
            :"target-org" => target_org,
          }
          json = exec(__method__, flags: flags, redirection: :null_stderr)
          json['result']
        end

        # returns a list of Salesforce object name
        #
        # *object_type* --- all or custom<br>
        #
        # *target_org* --- an alias of paticular org, or username can be used<br>
        #
        # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm#cli_reference_sobject_list_unified]
        #
        def list(object_type, target_org: nil)
          flags    = {
            :"sobject"    => (object_type.to_sym == :custom ? :custom : :all),
            :"target-org" => target_org,
          }
          json = exec(__method__, flags: flags, redirection: :null_stderr)
          json['result']
        end
      end
    end
  end
end
