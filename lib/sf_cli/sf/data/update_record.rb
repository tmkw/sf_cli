module SfCli::Sf::Data
  module UpdateRecord

    # update a object record. (eqivalent to *sf* *data* *update* *record*)
    #
    # *object_type* --- \Object Type (ex. Account)<br>
    # *record_id* --- id of the object<br>
    # *where* --- field values that is used to identify a record<br>
    # *values* --- field values for update<br>
    # *target_org* --- an alias of paticular org, not default one<br>
    #
    # ==== examples
    #   sf.data.update_record :Account, record_id: 'xxxxxxx', values: {Name: 'New Account Name'}
    #   sf.data.update_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}, values: {Phone: 'xxxxx', bar: 2000}
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_update_record_unified]
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
