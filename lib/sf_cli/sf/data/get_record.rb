module SfCli::Sf::Data
  module GetRecord

    # get a object record. (eqivalent to *sf* *data* *get* *record*)
    #
    # *object_type* --- \Object Type (ex. Account)<br>
    # *record_id* --- id of the object<br>
    # *where* --- hash object that is used to identify a record<br>
    # *target_org* --- an alias of paticular org, not default one<br>
    # *model_class* --- the object model class<br>
    #
    # ==== examples
    #   sf.data.get_record :Account, record_id: 'xxxxxxx'
    #   sf.data.get_record :Account, where: {Name: 'Jonny B.Good', Country: 'USA'}
    #
    #   CustomObject = Struct.new(:Id, :Name)
    #   sf.data.get_record :TheCustomObject__c, record_id: 'xxxxx', model_class: CustomObject  # returns a CustomObject struct object
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_get_record_unified]
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
