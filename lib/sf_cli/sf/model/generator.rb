require_relative './class_definition'

module SfCli
  module Sf
    module Model
      class Generator
        attr_reader :sf_sobject, :connection

        def initialize(connection)
          @connection = connection
        end

        def generate(object_name)
          schema = describe(object_name)
          class_definition = ClassDefinition.new(schema)

          instance_eval "::#{object_name} = #{class_definition}"
          klass = Object.const_get object_name.to_sym
          klass.connection = connection
        end

        def describe(object_name)
          connection.describe object_name
        end
      end
    end
  end
end
