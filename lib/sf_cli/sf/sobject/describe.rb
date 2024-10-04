require_relative './schema'

module SfCli::Sf::Sobject
  module Describe
    # Get a Salesforce object schema
    # @param object_type [Symbol,String] object type(ex: Account)
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    #
    # @return [Schema] a schema object that represents the object schema
    #
    # @example
    #   schema = sf.sobject.describe :Account
    #   schema.name  # Account
    #   schema.label # Account
    #   schema.field_names            # [:Id, :Name, ....]
    #   schema.fields.name_and_labels # [['Id', 'Account Id'], ['Name', 'Account Name'], ...]
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm#cli_reference_sobject_describe_unified command reference
    #
    def describe(object_type, target_org: nil, api_version: nil)
      flags    = {
        :"sobject"     => object_type,
        :"target-org"  => target_org,
        :"api-version" => api_version,
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)
      Schema.new(json['result'])
    end
  end
end
