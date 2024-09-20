module SfCli::Sf::Data
  module CreateRecord
    # create a object record.
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_create_record_unified command reference
    # @param object_type [Symbol, String] object type(ex. Account)
    # @param values      [Hash]           field values to be assigned
    # @param target_org  [Symbol, String] an alias of paticular org, or username can be used
    #
    # @return [String] record ID
    #
    # @example
    #   # create a TheCustomObject record with name and age
    #   sf.data.create_record :TheCustomObject__c, values: {Name: "John Smith", Age: 33}
    #
    def create_record(object_type, values: {}, target_org: nil)
      field_values = field_value_pairs(values)
      flags = {
        :"sobject"    => object_type,
        :"values"      => (field_values.nil? ? nil : %|"#{field_values}"|),
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      json['result']['id']
    end
  end
end
