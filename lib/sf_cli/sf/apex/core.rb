require_relative '../core/base'
require_relative './run'

module SfCli
  module Sf
    # Apex Commands
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm command reference
    #
    module Apex
      # @private :nodoc: just for developers
      class Core
        include ::SfCli::Sf::Core::Base
        include Run
      end
    end
  end
end
