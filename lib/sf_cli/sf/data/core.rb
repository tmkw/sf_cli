require_relative '../core/base'
require_relative './helper_methods'

module SfCli
  module Sf
    module Data
      #
      # ==== description
      # The class representing *sf* *data*
      #
      # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base
        include ::SfCli::Sf::Data::HelperMethods

        # get object records using SQOL. (eqivalent to *sf* *data* *query*)
        #
        # *soql* --- SOQL<br>
        # *target_org* --- an alias of paticular org, not default one<br>
        # *model_class* --- the object model class<br>
        #
        # == examples
        #   sf.data.query 'SELECT Id, Name FROM Account LIMIT 1' # => [{Id: "abc", Name: "account name"}]
        #
        #   Account = Struct.new(:Id, :Name)
        #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account struct object
        #
        #   # child-parent relationship is supported
        #   sf.data.query 'SELECT Id, Name, Account.Name From Contact Limit 1'  #  [{Id: "abc", Name: "contact name", Account: {Name: "account name"}}]
        #
        #   # parent-children relationship is supported
        #   sf.data.query 'SELECT Id, Name, (SELECT Name From Contacts) FROM Account Limit 1'  #  [{Id: "abc", Name: "account name", Contacts: [{Name: "contact name"}]}]
        #
        #   Account = Struct.new(:Id, :Name) # you can manually prepare the object model
        #   sf.data.query('SELECT Id, Name From Account Limit 3', model_class: Account)  # returns an array of Account
        #
        # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_query_unified]
        #
        # About querying with auto generated object model, see the section {"Object Model support"}[link://files/README_rdoc.html#label-Object+Model+support+-28experimental-2C+since+0.0.4-29] in README.
        #
        def query(soql, target_org: nil, format: nil, bulk: false, timeout: nil, model_class: nil)
          flags    = {
            :"query"    => %("#{soql}"),
            :"target-org" => target_org,
            :"result-format" => format,
            :"wait" => (bulk ? (timeout || 1) : nil),
          }
          switches = {
            bulk: bulk,
          }
          raw_output = format ? true : false
          format = format || :json

          result = exec(__method__, flags: flags, switches: switches, redirection: :null_stderr, raw_output: raw_output, format: format)
          return result if raw_output

          return create_query_bulk_response(result, model_class) if bulk

          result['result']['records'].each_with_object([]) do |h, a|
            record = prepare_record(h)
            a << (model_class ? model_class.new(**record) : record)
          end
        end

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

        private

        def create_query_bulk_response(result, model_class) # :nodoc:
          done = result['result']['done']
          id   = result['result']['id']
          rows = result['result']['records'].each_with_object([]) do |h, a|
              record = prepare_record_in_bulk_mode(h)
              a << (model_class ? model_class.new(**record) : record)
            end

          done ? [done, rows] : [done, id]
        end
      end
    end
  end
end
