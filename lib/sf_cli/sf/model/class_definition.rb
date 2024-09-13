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
              attr_reader :original_attributes, :current_attributes, :updated_attributes

              #{ class_methods }

              #{ field_attribute_methods  }
              #{ parent_relation_methods }
              #{ children_relation_methods }

              #{ define_initialize }
              #{ define_to_h }
              #{ define_save }
              #{ define_delete }
              #{ define_predicates }
            end
          Klass
        end

        def define_initialize
          @define_initialize ||= <<~EOS
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
          EOS
        end

        def define_to_h
          @define_to_h ||= <<~EOS
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

        def define_predicates
          @define_predicates ||= <<~EOS
            def new_record?
              self.Id.nil?
            end

            def persisted?
              new_record? == false
            end
          EOS
        end

        def define_save
          @define_save ||= <<~EOS
            def save
              if new_record?
                self.Id = self.class.connection.create(self.class.name.to_sym, current_attributes.reject{|_,v| v.nil?})
              else
                self.class.connection.update(self.class.name.to_sym, self.Id, nil, updated_attributes.reject{|_,v| v.nil?})
              end

              @original_attributes = current_attributes.dup
              @updated_attributes = {}

              self.Id
            end
          EOS
        end

        def define_delete
          @define_delete ||= <<~EOS
            def delete
              return if self.Id.nil?

              self.class.connection.delete(self.class.name.to_sym, self.Id)
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

        def field_attribute_methods
          schema.field_names.each_with_object('') do |name, s|
            s << <<~EOS
              def #{name}
                @#{name}
              end

              def #{name}=(value)
                @#{name} = value
                return if %i[Id LastModifiedDate IsDeleted SystemModstamp CreatedById CreatedDate LastModifiedById].include?(:#{name})

                current_attributes[:#{name}] = value
                if current_attributes[:#{name}] == original_attributes[:#{name}]
                  updated_attributes[:#{name}] = nil
                else
                  updated_attributes[:#{name}] = value
                end
              end
            EOS
          end
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
