module SfCli::Sf::Org
  module Display
    ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status)

    #
    # returns the org's connection information. (equivalent to *sf* *org* *display*)
    #
    # *target_org* --- an alias of paticular org, not default one<br>
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_display_unified]
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
