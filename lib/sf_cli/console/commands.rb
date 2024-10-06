require 'sf_cli'
require 'sf_cli/sf/model'
require 'sf_cli/sf/model/query_condition'
require 'sf_cli/sf/model/sf_command_connection'
require 'stringio'

module SfCli
  # @private :nodoc: just for developers
  module Console
    #
    # Developer Console commands
    #
    module Commands
      def use(target_org)
        org_info = sf.org.display target_org: target_org
        conn = SfCli::Sf::Model::SfCommandConnection.new target_org: target_org, instance_url: org_info.instance_url
        conn.open unless org_info.connected?

        SfCli::Sf::Model.set_connection conn

        available_models.each do |model|
          Object.const_get(model).connection = conn
        end

        true
      end

      def available_models
        @available_models ||= []
      end

      def generate(*object_types)
        SfCli::Sf::Model.generate object_types
        available_models.append(*object_types).flatten
        object_types
      end

      def connection
        SfCli::Sf::Model.connection
      end

      def target_org
        connection.target_org
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

      alias :gen  :generate
      alias :conn :connection

      def help
        conf.inspect_mode = false
        puts <<~HELP
          Available commands:
            use   --- set current org.
            gen   --- generate Object model classes
            query --- Query by SOQL with human readable format
            apex  --- run Apex code
            conn  --- show current connection setting
            orgs  --- show the list of org

          Syntax:
            [use]
              use target-org

              parameters:
                targat-org --- Username or alias of the org you are going to use. If you are not sure about them, check by `sf org list`.

              example:
                use :your_org_alias

            [gen]
              gen object-name, object-name, ...
              generate object-name, object-name, ...

              parameters:
                object-name --- Comma separated Names. Symbol or String can be OK. At least 1 object name is required.

              example:
                gen :Account, :Contact, :User

            [query]
              query SOQL

                parameters:
                  SOQL --- soql.You must quote it like "SELECT ...."

              example:
                query "SELECT Id, Name FROM Account LIMIT 3"

            [apex]
              apex apex_code

              parameters:
                apex code --- Apex code you want to execute.You must quote the code.

              example:
                apex "System.debug('abc');"

            [conn]
                conn
                connection

            [orgs]
                orgs
        HELP
        conf.inspect_mode = true
      end
    end
  end
end
