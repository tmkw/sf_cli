require 'singleton'
require 'json'

module SfCli
  module Sf

    # The entry class of sf command. It is returned by the sf method.
    # With including Singleton module, the instance of this class is guaranteed as singleton.
    #
    # @example
    #   sf             # returns a instance of SfCli::Sf
    #   sf.org.display # you can follow the similar syntax to the original command by using method chain.
    #
    # @private :nodoc: just for developers
    class Main
      include Singleton

      OPERATION_CATEGORIES = %w[Org Sobject Data Project Apex]

      OPERATION_CATEGORIES.each do |category|
        require_relative %(#{category.downcase}/core)
        attr_reader category.downcase.to_sym
      end

      # Generate each sub command object such as org, data and sobject
      # so that it can chain like `sf.org.display`.
      #
      def initialize
        OPERATION_CATEGORIES.each do |category|
          instance_variable_set(:"@#{category.downcase}", Object.const_get(%|::SfCli::Sf::#{category}::Core|).new)
        end
      end
    end
  end
end
