require_relative './schema'

module SfCli::Sf::Sobject
  module Describe
    # Returns a schema object containing the Salesforce object schema
    # @param object_type [Symbol,String] object type(ex: Account)
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    #
    # @return [Schema] a schema object that represents the object schema
    #
    # @example
    #   schema = sf.sobject.describe :Account
    #   schema.name  # Account
    #   schema.label # Account
    #   schema.field_names # [:Id, :Name, ....]
    #   schema.fields[:Name] # => {"aggregatable"=>true, "aiPredictionField"=>false, "autoNumber"=>false,...}
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm#cli_reference_sobject_describe_unified command reference
    #
    def describe(object_type, target_org: nil)
      flags    = {
        :"sobject"    => object_type,
        :"target-org" => target_org,
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)
      Schema.new(json['result'])
    end
  end
end
