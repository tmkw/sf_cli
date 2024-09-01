require_relative 'model/generator'

module SfCli
  module Sf
    module Model
      def self.generate(object_names, target_org: nil)
        generator = Generator.new(target_org: target_org)

        object_names.each do |object_name|
          generator.generate(object_name)
        end
      end
    end
  end
end
