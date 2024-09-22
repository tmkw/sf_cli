module SfCli::Sf::Sobject
  module List
    # Returns a list of Salesforce object name
    # @param object_type [Symbol,String] 'all' or 'custom'
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_sobject_commands_unified.htm#cli_reference_sobject_list_unified command reference
    #
    def list(object_type, target_org: nil, api_version: nil)
      flags    = {
        :"sobject"     => (object_type.to_sym == :custom ? :custom : :all),
        :"target-org"  => target_org,
        :"api-version" => api_version,
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)
      json['result']
    end
  end
end
