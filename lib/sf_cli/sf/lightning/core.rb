require_relative '../core/base'
require_relative './generate'

module SfCli
  module Sf
    #
    # Lightning Commands
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_lightning_commands_unified.htm command reference
    #
    module Lightning
      # @private :nodoc: just for developers
      class Core
        include ::SfCli::Sf::Core::Base
        include Generate
      end
    end
  end
end
