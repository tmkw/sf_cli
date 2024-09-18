require_relative '../core/base'
require_relative './run'

module SfCli
  module Sf
    module Apex
      #
      # ==== description
      # The class representing *sf* *apex*.
      #
      # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base
        include Run
      end
    end
  end
end
