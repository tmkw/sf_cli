require 'sf_cli'
require 'sf_cli/sf/model'
require 'sf_cli/sf/model/sf_command_connection'
require 'stringio'

module SfCli
  module Console
    module Commands
      def use(_target_org)
        target_org = _target_org.to_sym == :default ? nil : _target_org
        org_info = sf.org.display target_org: target_org
        conn = SfCli::Sf::Model::SfCommandConnection.new target_org: target_org, instance_url: org_info.instance_url
        SfCli::Sf::Model.set_connection conn
      end

      def generate(*object_types)
        SfCli::Sf::Model.generate object_types
      end

      def connection
        SfCli::Sf::Model.connection
      end

      def target_org
        connection.target_org
      end

      def apex(apex_code)
        sf.apex.run target_org: target_org, file: StringIO.new(apex_code)
      end

      alias :gen  :generate
      alias :conn :connection
    end
  end
end
