module SfCli
  module Sf
    module Model
      # @private :nodoc: just for developers
      module BaseMethods
        def self.included(c)
          c.extend ClassMethods
        end

        module ClassMethods
          def connection
            @connection
          end

          def connection=(conn)
            @connection = conn
          end

          def describe
            connection.describe(name.to_sym)
          end
        end

        def initialize(attributes = {})
          @original_attributes = {}
          @current_attributes = {}
          @updated_attributes = {}

          attributes.each do |k, v|
            field_name = k.to_sym
            if self.class.field_names.include?(field_name)
              @original_attributes[field_name] = v
              __send__ (field_name.to_s + '='), v
            elsif self.class.parent_relations.find{|r| r[:name] == field_name}
              __send__ (field_name.to_s + '='), v
            elsif self.class.children_relations.find{|r| r[:name] == field_name}
              __send__ (field_name.to_s + '='), (v.nil? ? [] : v)
            end
          end
        end

        def to_h(keys: nil)
          self.class.field_names.each_with_object({}) do |name, hash|
            if keys&.instance_of?(Array)
              hash[name] = __send__(name) if keys.include?(name)
            else
              hash[name] = __send__(name)
            end
          end
        end

        def new_record?
          self.Id.nil?
        end

        def persisted?
          new_record? == false
        end
      end
    end
  end
end

