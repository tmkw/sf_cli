require_relative 'model/generator'

module SfCli
  module Sf
    #
    # ==== description
    # The module for \Object \Model definition and generation
    #
    # see the section {"Object Model support"}[link://files/README_rdoc.html#label-Object+Model+support+-28experimental-2C+since+0.0.4-29] in README.
    #
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
