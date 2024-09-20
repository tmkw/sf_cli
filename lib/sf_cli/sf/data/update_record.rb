module SfCli::Sf::Data
  module UpdateRecord

    # Update a object record.
    # @param object_type [Symbol,String] object type(ex. Account)
    # @param record_id   [String]        ID of the object
    # @param where       [Hash]          field values to identify a record
    # @param values      [Hash]          field values for update
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # 
    # @return [String] ID of the record updated 
    # 
    # @example
    #   sf.data.update_record :Account, record_id: 'xxxxxxx', values: {Name: 'New Account Name'}
    #   sf.data.update_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}, values: {Phone: 'xxxxx', bar: 2000}
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_update_record_unified command reference
    #
    def update_record(object_type, record_id: nil, where: nil, values: nil, target_org: nil)
      where_conditions  = field_value_pairs(where)
      field_values      = field_value_pairs(values)
      flags = {
        :"sobject"    => object_type,
        :"record-id"  => record_id,
        :"where"      => (where_conditions.nil? ? nil : %|"#{where_conditions}"|),
        :"values"     => (field_values.nil? ? nil : %|"#{field_values}"|),
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      json['result']['id']
    end
  end
end
