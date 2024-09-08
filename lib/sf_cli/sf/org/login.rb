module SfCli::Sf::Org
  module Login
    # login to the org by the browser. (equivalent to *sf* *org* *login* *web*)
    #
    # *target_org* --- an alias of paticular org, not default one<br>
    # *instance_url* --- custom login url.
    #
    # == examples:
    #   sf.org.login_web
    #   sf.org.login_web target_org: :dev  # if the org you login isn't the default one, you should give it alias name for later use.
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_login_web_unified]
    #
    def login_web(target_org: nil, instance_url: nil, browser: nil)
      flags    = {
        :"alias"        => target_org,
        :"instance-url" => instance_url,
        :"browser"      => browser,
      }
      action = __method__.to_s.tr('_', ' ')
      exec(action, flags: flags)
    end
  end
end
