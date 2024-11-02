module SfCli::Sf::Org
  module Display
    ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status) do
        def connected?
          status == 'Connected'
        end
      end

    #
    # Returns the org's connection information
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param format      [Symbol,String] output format. json or human is available. (default: json)
    #
    # @note this function returns the org information including security sensitive things such as access token, username and so on.
    # @return [ConnectionInfo] the org's connection information
    #
    # @example
    #  (in irb):
    #  > sf.org.display
    #  =>
    #  #<struct SfCli::Sf::Org::Display::ConnectionInfo
    #   id="00D5j00000DiuxmEAB",
    #   access_token="<some access token>",
    #   alias="dev",
    #   instance_url="https://hoge-bar-baz.abc.my.salesforce.com.example",
    #   user_name="user@example.sandbox",
    #   api_version="61.0",
    #   status="Connected">
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_display_unified command reference
    #
    def display(target_org: nil, api_version: nil, format: :json)
      flags    = {:"target-org" => target_org, :"api-version" => api_version}
      output = org_exec(__method__, flags: flags, redirection: :null_stderr, format: format)
      return output if format.to_sym == :human

      ConnectionInfo.new(
        id:           output['result']['id'],
        access_token: output['result']['accessToken'],
        alias:        output['result']['alias'],
        instance_url: output['result']['instanceUrl'],
        user_name:    output['result']['username'],
        api_version:  output['result']['apiVersion'],
        status:       output['result']['connectedStatus']
      )
    end
  end
end
