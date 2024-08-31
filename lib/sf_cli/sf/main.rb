require 'singleton'
require 'json'

module SfCli
  module Sf
    # ==== description
    # The main class of *sf* command.
    #
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm
    #
    # ==== examples
    #  sf = SfCli::Sf.new # use default org
    #
    #  # get the org connection infomation, as same as 'sf org display'
    #  sf.org.display
    #
    #  # get Account records (equivalent to 'sf data query')
    #  sf.data.query 'SELECT Id, Name FROM Account LIMIT 3' # => returns an array containing 3 records
    #
    class Main
      include Singleton

      OPERATION_CATEGORIES = %w[Org Sobject Data Project]

      OPERATION_CATEGORIES.each do |category|
        require_relative %(#{category.downcase}/core)
        attr_reader category.downcase.to_sym
      end

      def initialize
        OPERATION_CATEGORIES.each do |category|
          instance_variable_set(:"@#{category.downcase}", Object.const_get(%|::SfCli::Sf::#{category}::Core|).new)
        end
      end
    end
  end
end
