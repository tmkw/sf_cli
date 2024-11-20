require 'sf_cli'
require 'byebug'
require 'stringio'

module SfCli
  # @private :nodoc: just for developers
  module Console
    #
    # Developer Console commands
    #
    module Commands
      def target_org
        @target_org
      end

      def apex(apex_code = nil)
        return sf.apex.run target_org: target_org if apex_code.nil?

        sf.apex.run target_org: target_org, file: StringIO.new(apex_code)
      end

      def query(_soql)
        soql = _soql.is_a?(SfCli::Sf::Model::QueryMethods::QueryCondition) ? _soql.to_soql : _soql
        conf.inspect_mode = false
        puts sf.data.query(soql, format: :human, target_org: target_org)
        conf.inspect_mode = true
      end

      def orgs
        conf.inspect_mode = false
        system 'sf org list'
        conf.inspect_mode = true
      end
    end
  end
end
