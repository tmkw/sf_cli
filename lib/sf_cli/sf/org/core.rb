require_relative '../core/base'
require_relative './login'
require_relative './display'
require_relative './list'

module SfCli
  module Sf
    module Org
      #
      # ==== description
      # The class representing *sf* *org*.
      #
      # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base
        include Login
        include Display
        include List
      end
    end
  end
end
