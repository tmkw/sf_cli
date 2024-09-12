require_relative './schema'

module SfCli
  module Sf
    module Model
      class ClassDefinition
        attr_reader :schema

        def initialize(schema)
          @schema = Schema.new(schema)
        end

        def to_s
          <<~Klass
            Class.new do
              #{ class_methods }

              field_names.each do |name|
                attr_accessor name
              end

              #{ parent_relation_methods }
              #{ children_relation_methods }

              #{ define_initialize }

              #{ define_to_h }
            end
          Klass
        end

        def define_initialize
          <<~EOS
            def initialize(attributes = {})
              attributes.each do |k, v|
                field_name = k.to_sym
                if self.class.field_names.include?(field_name)
                  #instance_variable_set ('@' + field_name.to_s).to_sym, v
                  __send__ (field_name.to_s + '='), v
                elsif self.class.parent_relations.find{|r| r[:name] == field_name}
                  __send__ (field_name.to_s + '='), v
                elsif self.class.children_relations.find{|r| r[:name] == field_name}
                  __send__ (field_name.to_s + '='), (v.nil? ? [] : v)
                end
              end
            end
          EOS
        end

        def define_to_h
          <<~EOS
            def to_h(keys: nil)
              self.class.field_names.each_with_object({}) do |name, hash|
                if keys&.instance_of?(Array)
                  hash[name] = __send__(name) if keys.include?(name)
                else
                  hash[name] = __send__(name)
                end
              end
            end
          EOS
        end

        def class_methods
          <<~EOS
            class << self
              def field_names
                @field_names ||= #{ schema.field_names }
              end

              def parent_relations
                @parent_relations ||= #{ schema.parent_relations }
              end

              def children_relations
                @children_relations ||= #{ schema.children_relations }
              end

              def connection
                @connection
              end

              def connection=(conn)
                @connection = conn
              end

              def create(values = {})
                connection.create(name.to_sym, values, Object.const_get(name.to_sym))
              end

              def take(id)
                connection.take(name.to_sym, id, Object.const_get(name.to_sym))
              end
            end
          EOS
        end

        def parent_relation_methods
          schema.parent_relations.each_with_object('') do |r, s|
            s << <<~EOS
              def #{r[:name]}
                @#{r[:name]}
              end

              def #{r[:name]}=(attributes)
                @#{r[:name]} = #{r[:class_name]}.new(attributes)
              end
            EOS
          end
        end

        def children_relation_methods
          schema.children_relations.each_with_object('') do |r, s|
            s << <<~EOS
              def #{r[:name]}
                @#{r[:name]}
              end

              def #{r[:name]}=(records)
                @#{r[:name]} = records.map{|attributes| #{r[:class_name]}.new(attributes)}
              end
            EOS
          end
        end
      end
    end
  end
end
