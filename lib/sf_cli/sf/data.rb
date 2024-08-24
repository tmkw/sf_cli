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
        json = sf.exec(category, __method__, flags: flags, redirection: :null_stderr)

        json['result']['records'].each_with_object([]) do |h, a|
          h.delete "attributes"
          a << (model_class ? model_class.new(**h) : h)
        end
      end
    end
  end
end
