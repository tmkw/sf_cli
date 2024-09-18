require 'singleton'
require 'json'

module SfCli
  module Sf
    # ==== description
    # The entry class of sf command. It is returned by sf method.
    # With including Singleton module, the instance of this class is guaranteed as singleton.
    #
    # ==== examples
    #   sf             # returns a instance of SfCli::Sf
    #   sf.org.display # you can follow the similar syntax to the original command by using method chain.
    #
    class Main
      include Singleton

      OPERATION_CATEGORIES = %w[Org Sobject Data Project Apex]

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
