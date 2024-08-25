require_relative './base'

module SfCli
  class Sf
    #
    # ==== description
    # The class representing *sf* *data*
    #
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm
    #
    class Data < Base

      # get the object records. (eqivalent to *sf* *data* *query*)
      #
      # *soql* --- SOQL<br>
      # *target_org* --- an alias of paticular org, not default one<br>
      # *model_class* --- the data model class representing the record object.<br> 
      #
      # ==== examples
      #   sf.data.query('SELECT Id, Name From Account Limit 3') # returns an array of Hash object
      #
      #   Account = Struct.new(:Id, :Name)
      #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account struct object
      #
      def query(soql, target_org: nil, model_class: nil)
        flags    = {
          :"query"    => %("#{soql}"),
          :"target-org" => target_org,
        }
        json = exec(__method__, flags: flags, redirection: :null_stderr)

        json['result']['records'].each_with_object([]) do |h, a|
          h.delete "attributes"
          a << (model_class ? model_class.new(**h) : h)
        end
      end

      # get a object record. (eqivalent to *sf* *data* *get* *record*)
      #
      # *object_type* --- Object Type (ex. Account)<br>
      # *record_id* --- id of the object<br>
      # *where* --- hash object that is used to identify a record<br>
      # *target_org* --- an alias of paticular org, not default one<br>
      # *model_class* --- the data model class representing the record object.<br> 
      #
      # ==== examples
      #   sf.data.get_record :Account, record_id: 'xxxxxxx'
      #   sf.data.get_record :Account, where: {Name: 'Jonny B.Good', Country: 'USA'}
      #
      #   CustomObject = Struct.new(:Id, :Name)
      #   sf.data.get_record :TheCustomObject__c, record_id: 'xxxxx', model_class: CustomObject  # returns a CustomObject struct object
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
end
