module SfCli::Sf::Org
  module Login
    # login to the org by the browser.
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # *instance_url* --- URL of the instance that the org lives on.
    #
    # *browser* --- browser in which to open the org.
    #
    # == examples:
    #   sf.org.login_web
    #   sf.org.login_web target_org: :dev
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_login_web_unified]
    #
    def login_web(target_org: nil, instance_url: nil, browser: nil)
      flags = {
        :"alias"        => target_org,
        :"instance-url" => instance_url,
        :"browser"      => browser,
      }
      action = __method__.to_s.tr('_', ' ')
      exec(action, flags: flags)
    end

    # login to the org by access token.
    #
    # NOTE: this method doesn't support user interactive mode, so *SF_ACCESS_TOKEN* environment variable must be set before call this method.
    #
    # *instance_url* --- URL of the instance that the org lives on.
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # ======
    #  ENV['SF_ACCESS_TOKEN'] = 'xxxxxxxxxx'
    #  sf.org.login_access_token instance_url: https://hoge.bar.baz.salesforce.com
    #
    # == how to set env variable outside of ruby
    # In Unix/mac:
    #   $ SF_ACCESS_TOKEN='xxxxxxxxxx'
    #   $ ruby app_using_sfcli.rb
    # or
    #   $ SF_ACCESS_TOKEN='xxxxxxxxxx' ruby app_using_sfcli.rb
    #
    # In Windows:
    #   $ set SF_ACCESS_TOKEN=xxxxxxxxxx
    #   $ ruby app_using_sfcli.rb
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_login_access-token_unified]
    #
    def login_access_token(instance_url:, target_org: nil)
      flags = {
        :"instance-url" => instance_url,
        :"alias"        => target_org,
      }
      switches = {
        :"no-prompt" => true,
      }
      action = __method__.to_s.tr('_', '-').sub('-', ' ')
      exec action, flags: flags, switches: switches, redirection: :null_stderr
    end
  end
end
