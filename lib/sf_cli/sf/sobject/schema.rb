module SfCli
  module Sf
    module Sobject
      class Schema
        attr_reader :schema

        def initialize(schema)
          @schema = schema
        end

        def all
          schema
        end

        def name
          @name ||= schema['name']
        end

        def label
          @label ||= schema['label']
        end

        def field_names
          @field_names ||= schema['fields'].map{|f| f['name'].to_sym}
        end

        def fields
          @field_map ||= schema['fields'].each_with_object({}) do |f, h|
            h[f['name'].to_sym] = f
          end
        end

        def children_relations
          schema['childRelationships']
            .select{|r| r['relationshipName'].nil? == false}
            .map{|r| {name: r['relationshipName'].to_sym, field: r['field'].to_sym, class_name: r['childSObject'].to_sym}}
        end

        def parent_relations
          schema['fields']
            .select{|f| f['relationshipName'].nil? == false && f['referenceTo']&.size > 0}
            .map{|f| {name: f['relationshipName'].to_sym, field: f['name'].to_sym, class_name: f['referenceTo'].first.to_sym}}
        end
      end
    end
  end
end
