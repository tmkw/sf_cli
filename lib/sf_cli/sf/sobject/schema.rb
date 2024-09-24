module SfCli
  module Sf
    module Sobject
      class Schema
        def initialize(schema)
          @schema = schema
        end

        def name
          schema['name']
        end

        def label
          schema['label']
        end

        def fields
          @fields ||= Fields.new(schema)
        end

        def field_names
          @field_names ||= fields.map{|f| f.name.to_sym}
        end

        def field_labels
          @field_labels ||= fields.map{|f| f.label}
        end

        def children_relations
          schema['childRelationships']
            .select{|r| r['relationshipName'].nil? == false}
            .map{|r| {name: r['relationshipName'].to_sym, field: r['field'].to_sym, class_name: r['childSObject'].to_sym}}
        end

        def parent_relations
          fields
            .select{|f| !(f.relationship_name.nil? || f.reference_to.nil?) && f.reference_to.size > 0}
            .map{|f| {name: f.relationship_name.to_sym, field: f.name.to_sym, class_name: f.reference_to.first.to_sym} }
        end

        def to_h
          schema
        end

        def compact_layoutable?
          schema["compactLayoutable"]
        end

        def createable?
          schema["createable"]
        end

        def custom?
          schema["custom"]
        end

        def custom_setting?
          schema["customSetting"]
        end

        def deep_cloneable?
          schema["deepCloneable"]
        end

        def default_implementation
          schema["defaultImplementation"]
        end

        def deletable?
          schema["deletable"]
        end

        def deprecated_and_hidden?
          schema["deprecatedAndHidden"]
        end

        def extended_by
          schema["extendedBy"]
        end

        def extends_interfaces
          schema["extendsInterfaces"]
        end

        def feed_enabled?
          schema["feedEnabled"]
        end

        def has_subtypes?
          schema["hasSubtypes"]
        end

        def implemented_by
          schema["implementedBy"]
        end

        def implements_interfaces
          schema["implementsInterfaces"]
        end

        def interface?
          schema["isInterface"]
        end

        def subtype?
          schema["isSubtype"]
        end

        def key_prefix
          schema["keyPrefix"]
        end

        def label_plural
          schema["labelPlural"]
        end

        def layoutable?
          schema["layoutable"]
        end

        def listviewable?
          schema["listviewable"]
        end

        def lookup_layoutable
          schema["lookupLayoutable"]
        end

        def mergeable?
          schema["mergeable"]
        end

        def mruEnabled
          schema["mruEnabled"]
        end

        def named_layouts
          schema["namedLayoutInfos"]
        end

        def network_scope_field_name
          schema["networkScopeFieldName"]
        end

        def queryable?
          schema["queryable"]
        end

        def record_types
          schema["recordTypeInfos"]
        end

        def replicateable?
          schema["replicateable"]
        end

        def retrieveable?
          schema["retrieveable"]
        end

        def search_layoutable?
          schema["searchLayoutable"]
        end

        def searchable?
          schema["searchable"]
        end

        def sobject_describe_option
          schema["sobjectDescribeOption"]
        end

        def supported_scopes
          schema["supportedScopes"]
        end

        def triggerable?
          schema["triggerable"]
        end

        def undeletable?
          schema["undeletable"]
        end

        def updateable?
          schema["updateable"]
        end

        def urls
          schema["urls"]
        end

        private

        def schema
          @schema
        end

        class Fields
          include Enumerable

          def initialize(schema)
            @fields = schema['fields'].map{|h| Field.new(**h)}
          end

          def each(&block)
            fields.each &block
          end

          def to_a
            fields
          end

          def find_by(name: nil, label: nil)
            return nil if name.nil? && label.nil?

            attr_name = name.nil? ? :label : :name
            val       = name || label

            find do |field|
              attr_val = field.__send__(attr_name.to_sym)
              attr_val == val
            end
          end

          def name_and_labels
            map{|field| [field.name, field.label]}
          end

          private

          def fields
            @fields
          end
        end

        class Field
          def initialize(field)
            @field = field
          end

          def aggregatable?
            field["aggregatable"]
          end

          def ai_prediction_field?
            field["aiPredictionField"]
          end

          def autoNumber?
            field["autoNumber"]
          end

          def byteLength
            field["byteLength"]
          end

          def calculated?
            field["calculated"]
          end

          def calculated_formula
            field["calculatedFormula"]
          end

          def cascade_delete?
            field["cascadeDelete"]
          end

          def case_sensitive
            field["caseSensitive"]
          end

          def compound_field_name
            field["compoundFieldName"]
          end

          def controller_name
            field["controllerName"]
          end

          def createable?
            field["createable"]
          end

          def custom?
            field["custom"]
          end

          def default_value
            field["defaultValue"]
          end

          def default_value_formula
            field["defaultValueFormula"]
          end

          def defaulted_on_create?
            field["defaultedOnCreate"]
          end

          def dependent_picklist?
            field["dependentPicklist"]
          end

          def deprecated_and_hidden?
            field["deprecatedAndHidden"]
          end

          def digits
            field["digits"]
          end

          def display_location_in_decimal?
            field["displayLocationInDecimal"]
          end

          def encrypted?
            field["encrypted"]
          end

          def external_id?
            field["externalId"]
          end

          def extra_type_info
            field["extraTypeInfo"]
          end

          def filterable?
            field["filterable"]
          end

          def filtered_lookup_info
            field["filteredLookupInfo"]
          end

          def formula_treat_null_number_as_zero?
            field["formulaTreatNullNumberAsZero"]
          end

          def groupable?
            field["groupable"]
          end

          def high_scale_number?
            field["highScaleNumber"]
          end

          def html_formatted?
            field["htmlFormatted"]
          end

          def id_lookup?
            field["idLookup"]
          end

          def inline_help_text
            field["inlineHelpText"]
          end

          def label
            field["label"]
          end

          def length
            field["length"]
          end

          def mask
            field["mask"]
          end

          def mask_type
            field["maskType"]
          end

          def name
            field["name"]
          end

          def name_field?
            field["nameField"]
          end

          def name_pointing?
            field["namePointing"]
          end

          def nillable?
            field["nillable"]
          end

          def permissionable?
            field["permissionable"]
          end

          def picklist_values
            field["picklistValues"]
          end

          def polymorphic_foreign_key?
            field["polymorphicForeignKey"]
          end

          def precision
            field["precision"]
          end

          def query_by_distance?
            field["queryByDistance"]
          end

          def reference_target_field
            field["referenceTargetField"]
          end

          def reference_to
            field["referenceTo"]
          end

          def relationship_name
            field["relationshipName"]
          end

          def relationship_order
            field["relationshipOrder"]
          end

          def restricted_delete
            field["restrictedDelete"]
          end

          def restricted_picklist?
            field["restrictedPicklist"]
          end

          def scale
            field["scale"]
          end

          def search_prefilterable?
            field["searchPrefilterable"]
          end

          def soapType
            field["soapType"]
          end

          def sortable?
            field["sortable"]
          end

          def type
            field["type"]
          end

          def unique?
            field["unique"]
          end

          def updateable?
            field["updateable"]
          end

          def write_Requires_Master_Read?
            field["writeRequiresMasterRead"]
          end

          def to_h
            field
          end

          private

          def field
            @field
          end
        end
      end
    end
  end
end
