module SfCli::Sf::Data
  module DeleteRecord
    # delete a object record. (eqivalent to *sf* *data* *delete* *record*)
    #
    # *object_type* --- \Object Type (ex. Account)<br>
    # *record_id* --- id of the object<br>
    # *where* --- hash object that is used to identify a record<br>
    # *target_org* --- an alias of paticular org, not default one<br>
    #
    # ==== examples
    #   sf.data.delete_record :Hoge__c, record_id: 'xxxxxxx'
    #   sf.data.delete_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_delete_record_unified]
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
