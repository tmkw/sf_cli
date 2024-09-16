require_relative './base_methods'
require_relative './dml_methods'
require_relative './query_methods'

module SfCli
  module Sf
    module Model
      class ClassDefinition
        attr_reader :schema

        def initialize(schema)
          @schema = schema
        end

        def to_s
          <<~Klass
            Class.new do
              include ::SfCli::Sf::Model::BaseMethods
              include ::SfCli::Sf::Model::DmlMethods
              include ::SfCli::Sf::Model::QueryMethods

              attr_reader :original_attributes, :current_attributes, :updated_attributes

              #{ class_methods }

              #{ field_attribute_methods  }
              #{ parent_relation_methods }
              #{ children_relation_methods }
            end
          Klass
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
                @#{r[:name]} = attributes.nil? ? nil : #{r[:class_name]}.new(attributes)
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
