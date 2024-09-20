module SfCli::Sf::Data
  module GetRecord

    # Get a object record.
    # @param object_type [Symbol,String] object type(ex. Account)
    # @param record_id   [String]        id of the object
    # @param where       [Hash]          conditions to identify a record
    # @param target_org  [Symbol,String] an alias of paticular org, not default one
    # @param model_class [Class]         the object model class
    #
    # @return [Hash,Class] if proper model class is specified, the return value is the instance of the class. Otherwise, it's a Hash object.
    #
    # @example
    #   sf.data.get_record :Account, record_id: 'xxxxxxx'
    #   sf.data.get_record :Account, where: {Name: 'Jonny B.Good', Country: 'USA'}
    #
    #   CustomObject = Struct.new(:Id, :Name)
    #   obj = sf.data.get_record :TheCustomObject__c, record_id: 'xxxxx', model_class: CustomObject # returns a CustomObject instance
    #   obj.Name # Name field of the record
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_get_record_unified command reference
    #
    def get_record(object_type, record_id: nil, where: nil, target_org: nil, model_class: nil)
      where_conditions = field_value_pairs(where)
      flags = {
        :"sobject"    => object_type,
        :"record-id"  => record_id,
        :"where"      => (where_conditions.nil? ? nil : %|"#{where_conditions}"|),
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      result = json['result']
      result.delete 'attributes'

      model_class ? model_class.new(**result) : result
    end
  end
end
