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

      # get object records using SQOL. (eqivalent to *sf* *data* *query*)
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
          record = HelperMethods.prepare_record(h)
          a << (model_class ? model_class.new(**record) : record)
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

      # update a object record. (eqivalent to *sf* *data* *update* *record*)
      #
      # *object_type* --- Object Type (ex. Account)<br>
      # *record_id* --- id of the object<br>
      # *where* --- field values that is used to identify a record<br>
      # *values* --- field values for update<br>
      # *target_org* --- an alias of paticular org, not default one<br>
      #
      # ==== examples
      #   sf.data.update_record :Account, record_id: 'xxxxxxx', values: {Name: 'New Account Name'}
      #   sf.data.update_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}, values: {Phone: 'xxxxx', bar: 2000}
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

      # create a object record. (eqivalent to *sf* *data* *create* *record*)
      #
      # *object_type* --- Object Type (ex. Account)<br>
      # *values* --- field values to be assigned<br>
      # *target_org* --- an alias of paticular org, not default one<br>
      #
      # ==== examples
      #
      #   sf.data.create_record :TheCustomObject__c, values: {Name: "John Smith", Age: 33} # creating a TheCustomObject record with name and age
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

      # delete a object record. (eqivalent to *sf* *data* *delete* *record*)
      #
      # *object_type* --- Object Type (ex. Account)<br>
      # *record_id* --- id of the object<br>
      # *where* --- hash object that is used to identify a record<br>
      # *target_org* --- an alias of paticular org, not default one<br>
      #
      # ==== examples
      #   sf.data.delete_record :Hoge__c, record_id: 'xxxxxxx'
      #   sf.data.delete_record :Hoge__c, where: {Name: 'Jonny B.Good', Country: 'USA'}
      #
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

      class HelperMethods
        def self.prepare_record(hash)
          hash.delete 'attributes'

          hash.keys.each do |k|
            if parent?(hash[k])
              hash[k] = prepare_record(hash[k])
            elsif children?(hash[k])
              hash[k] = hash[k]['records'].map{|h| prepare_record(h)}
            end
          end

          hash
        end

        def self.children?(h)
          return false unless h.instance_of?(Hash)

          h.has_key? 'records'
        end

        def self.parent?(h)
          return false unless h.instance_of?(Hash)

          h.has_key?('records') == false
        end
      end
    end
  end
end
