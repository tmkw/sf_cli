module SfCli::Sf::Org
  module Display
    ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status)

    #
    # Returns the org's connection information
    # @param target_org [Symbol,String] an alias of paticular org, or username can be used
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
    def display(target_org: nil)
      flags    = {:"target-org" => target_org}
      json = exec(__method__, flags: flags, redirection: :null_stderr)

      ConnectionInfo.new(
        id:           json['result']['id'],
        access_token: json['result']['accessToken'],
        alias:        json['result']['alias'],
        instance_url: json['result']['instanceUrl'],
        user_name:    json['result']['username'],
        api_version:  json['result']['apiVersion'],
        status:       json['result']['connectedStatus']
      )
    end
  end
end
