require_relative '../sobject/core'
require_relative '../data/core'
require_relative '../org/core'

module SfCli
  module Sf
    module Model
      class SfCommandConnection
        attr_reader :sf_data, :sf_sobject, :sf_org, :target_org, :instance_url

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

        def take(object_type, id, klass)
          sf_data.get_record object_type, record_id: id, target_org: target_org, model_class: klass
        end

        def create(object_type, values, klass)
          id = sf_data.create_record object_type, values: values, target_org: target_org
          take(object_type, id, klass)
        end

        private

        def describe(object_type)
          sf_sobject.describe object_type, target_org: target_org
        end
      end
    end
  end
end
