module SfCli
  module Sf
    module Model
      class Schema
        attr_reader :schema

        def initialize(schema)
          @schema = schema
        end

        def name
          schema['name']
        end

        def field_names
          schema['fields'].map{|f| f['name'].to_sym}
        end

        def children_relations
          schema['childRelationships']
            .select{|r| r['relationshipName'].nil? == false}
            .map{|r| {name: r['relationshipName'].to_sym, class_name: r['childSObject'].to_sym}}
        end

        def parent_relations
          schema['fields']
            .select{|f| f['relationshipName'].nil? == false && f['referenceTo']&.size > 0}
            .map{|f| {name: f['relationshipName'].to_sym, class_name: f['referenceTo'].first.to_sym}}
        end
      end
    end
  end
end
