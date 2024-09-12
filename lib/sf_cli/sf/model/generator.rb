require_relative '../sobject/core'
require_relative './class_definition'

module SfCli
  module Sf
    module Model
      class Generator
        attr_reader :sf_sobject, :connection

        def initialize(connection)
          @connection = connection
          @sf_sobject = ::SfCli::Sf::Sobject::Core.new
        end

        def generate(object_name)
          class_definition = ClassDefinition.new(describe object_name)

          instance_eval "::#{object_name} = #{class_definition}"
          klass = Object.const_get object_name.to_sym
          klass.connection = connection
        end

        def describe(object_name)
          sf_sobject.describe object_name, target_org: connection.target_org
        end
      end
    end
  end
end
