require_relative '../core/base'
require_relative './describe'
require_relative './list'

module SfCli
  module Sf
    #
    # SObject Commands
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm command reference
    #
    module Sobject
      # @private :nodoc: just for developers
      class Core
        include ::SfCli::Sf::Core::Base
        include Describe
        include List
      end
    end
  end
end
