require_relative '../core/base'
require_relative './generate'
require_relative './generate_manifest'
require_relative './retrieve_start'
require_relative './deploy_start'

module SfCli
  module Sf
    #
    # Project Commands
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm command reference
    #
    module Project
      # @private :nodoc: just for developers
      class Core
        include ::SfCli::Sf::Core::Base
        include Generate
        include GenerateManifest
        include RetrieveStart
        include DeployStart
      end
    end
  end
end
