require_relative '../sobject/core'
require_relative './class_definition'

module SfCli
  module Sf
    module Model
      class Generator
        attr_reader :sf_sobject, :target_org

        def initialize(target_org: nil)
          @sf_sobject = ::SfCli::Sf::Sobject::Core.new
          @target_org = target_org
        end

        def generate(object_name)
          class_definition = ClassDefinition.new(describe object_name)

          instance_eval "::#{object_name} = #{class_definition}"
        end

        def describe(object_name)
          sf_sobject.describe object_name, target_org: target_org
        end
      end
    end
  end
end
