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

        # returns a hash object containing the Salesforce object schema. (equivalent to *sf* *sobject* *describe*)
        #
        # *objectType* --- object type (ex: Account)<br>
        # *target_org* --- an alias of paticular org, not default one<br>
        #
        def describe(object_type, target_org: nil)
          flags    = {
            :"sobject"    => object_type,
            :"target-org" => target_org,
          }
          json = exec(__method__, flags: flags, redirection: :null_stderr)
          json['result']
        end

        # returns a list of Salesforce object API name. (equivalent to *sf* *sobject* *list*)
        #
        # *object_type* --- all or custom<br>
        # *target_org* --- an alias of paticular org, not default one<br>
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
