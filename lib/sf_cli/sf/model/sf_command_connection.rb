require_relative '../sobject/core'
require_relative '../data/core'
require_relative '../org/core'

module SfCli
  module Sf
    module Model
      #
      # Connection object to access Salesforce based on Sf command
      #
      class SfCommandConnection
        attr_reader :target_org, :instance_url

        # @private :nodoc: just for developers
        attr_reader :sf_data, :sf_org, :sf_sobject

        # @param target_org   [Symbol,String] an alias of paticular org, or username can be used
        # @param instance_url [String]        URL of the instance that the org lives on.
        #
        def initialize(target_org: nil, instance_url: nil)
          @sf_org = ::SfCli::Sf::Org::Core.new
          @sf_data = ::SfCli::Sf::Data::Core.new
          @sf_sobject = ::SfCli::Sf::Sobject::Core.new
          @target_org = target_org
          @instance_url = instance_url
        end

        def open
          if ENV['SF_ACCESS_TOKEN']
            sf_org.login_access_token target_org: target_org, instance_url: instance_url
          else
            sf_org.login_web target_org: target_org, instance_url: instance_url
          end
        end

        # Sf command style query interface for Model module
        #
        # For query details, see {SfCli::Sf::Data::Query sf data query}
        #
        def exec_query(soql, format: nil, bulk: false, wait: nil, model_class: nil)
          sf_data.query(soql, target_org: target_org, format: format, bulk: bulk, wait: wait, model_class: model_class)
        end

        # @private :nodoc: just for developers
        def find(object_type, id, klass)
          sf_data.get_record object_type, record_id: id, target_org: target_org, model_class: klass
        end

        # @private :nodoc: just for developers
        def create(object_type, values, klass = nil)
          id = sf_data.create_record object_type, values: values, target_org: target_org
          return id if klass.nil?

          find(object_type, id, klass)
        end

        # @private :nodoc: just for developers
        def update(object_type, id, values)
          sf_data.update_record object_type, record_id: id, where: nil, values: values, target_org: target_org
        end

        # @private :nodoc: just for developers
        def delete(object_type, id)
          sf_data.delete_record object_type, record_id: id, where: nil, target_org: target_org
        end

        # @private :nodoc: just for developers
        def query(soql, klass, format = nil)
          sf_data.query soql, target_org: target_org, format: format, model_class: klass
        end

        # @private :nodoc: just for developers
        def describe(object_type)
          sf_sobject.describe(object_type, target_org: target_org)
        end
      end
    end
  end
end
