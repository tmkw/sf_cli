module SfCli::Sf::Org
  module Login
    # Login to the org by the browser.
    # @param target_org   [Symbol,String] an alias of paticular org, or username can be used
    # @param instance_url [String]        URL of the instance that the org lives on.
    # @param browser      [Symbol,String] browser in which to open the org.
    #
    # @example
    #   sf.org.login_web
    #   sf.org.login_web target_org: :dev
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_login_web_unified command reference
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

    # @note This method doesn't support user interactive mode, so *SF_ACCESS_TOKEN* environment variable must be set before calling this method.
    # Login to the org by access token.
    #
    # If you don't set *SF_ACCESS_TOKEN* in the code, you have to set it outside of the script:
    #
    # In Unix/mac
    #   $ SF_ACCESS_TOKEN='xxxxxxxxxx'
    #   $ ruby app_using_sfcli.rb
    # OR
    #   $ SF_ACCESS_TOKEN='xxxxxxxxxx' ruby app_using_sfcli.rb
    #
    # In Windows
    #   > set SF_ACCESS_TOKEN=xxxxxxxxxx
    #   > ruby app_using_sfcli.rb
    #
    # @param target_org   [Symbol,String] an alias of paticular org, or username can be used
    # @param instance_url [String]        URL of the instance that the org lives on.
    #
    # @example
    #   ENV['SF_ACCESS_TOKEN'] = 'xxxxxxxxxx'
    #   sf.org.login_access_token instance_url: 'https://hoge.bar.baz.salesforce.com'
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_login_access-token_unified command reference
    #
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
