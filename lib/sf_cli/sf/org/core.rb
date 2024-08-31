require_relative '../operation_base'

module SfCli
  module Sf
    module Org
      #
      # ==== description
      # The class representing *sf* *org*.
      #
      # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm
      #
      class Core < OperationBase
        ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status)

        # login to the org by the browser. (equivalent to *sf* *org* *login* *web*)
        #
        # *target_org* --- an alias of paticular org, not default one<br>
        # *instance_url* --- custom login url.
        #
        def login_web(target_org: nil, instance_url: nil)
          flags    = {
            :"alias"        => target_org,
            :"instance-url" => instance_url,
          }
          action = __method__.to_s.tr('_', ' ')
          exec(action, flags: flags)
        end

        #
        # returns the org's connection information. (equivalent to *sf* *org* *display*)
        #
        # *target_org* --- an alias of paticular org, not default one<br>
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
  end
end
