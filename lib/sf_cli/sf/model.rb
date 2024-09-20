require_relative 'model/generator'

module SfCli
  module Sf
    #
    # The module for object model definition and generation
    #
    module Model
      # The connection object to access Salesforce
      def self.connection
        @@connection
      end

      # set the connection
      def self.set_connection(conn)
        @@connection = conn
      end

      # generate object models
      # @param object_names [Array] a list of object name
      #
      def self.generate(object_names)
        generator = Generator.new(connection)

        object_names.each do |object_name|
          generator.generate(object_name)
        end
      end
    end
  end
end
