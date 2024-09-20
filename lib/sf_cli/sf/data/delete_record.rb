module SfCli::Sf::Data
  module DeleteRecord
    # Delete a object record.
    #
    # @param object_type [Symbol, String] Object Type (ex. Account)
    # @param record_id   [String]         Id of the object
    # @param where       [Hash]           conditions to identify a record
    # @param target_org  [Symbol, String] an alias of paticular org, or username can be used
    #
    # @return [String] ID that is deleted.
    #
    # @example
    #   sf.data.delete_record :Hoge__c, record_id: 'xxxxxxx'
    #   sf.data.delete_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_record_unified the command reference
    #
    def delete_record(object_type, record_id: nil, where: nil, target_org: nil)
      where_conditions = field_value_pairs(where)
      flags = {
        :"sobject"    => object_type,
        :"record-id"  => record_id,
        :"where"      => (where_conditions.nil? ? nil : %|"#{where_conditions}"|),
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      json['result']['id']
    end
  end
end
