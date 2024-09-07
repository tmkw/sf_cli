module SfCli::Sf::Data
  module CreateRecord
    # create a object record. (eqivalent to *sf* *data* *create* *record*)
    #
    # *object_type* --- \Object Type (ex. Account)<br>
    # *values* --- field values to be assigned<br>
    # *target_org* --- an alias of paticular org, not default one<br>
    #
    # ==== examples
    #
    #   sf.data.create_record :TheCustomObject__c, values: {Name: "John Smith", Age: 33} # creating a TheCustomObject record with name and age
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_create_record_unified]
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
