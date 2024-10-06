require_relative './class_definition'

module SfCli
  module Sf
    module Model
      # @private :nodoc: just for developers
      class Generator
        attr_reader :connection

        def initialize(connection)
          @connection = connection
        end

        def generate(object_name)
          return false if generated? object_name

          schema = describe(object_name)
          class_definition = ClassDefinition.new(schema)

          instance_eval "::#{object_name} = #{class_definition}"
          klass = Object.const_get object_name.to_sym
          klass.connection = connection

          true
        end

        def describe(object_name)
          connection.describe object_name
        end

        def generated?(object_name)
          Object.const_get object_name.to_sym
          true
        rescue NameError
          false
        end
      end
    end
  end
end
