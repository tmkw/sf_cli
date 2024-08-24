require_relative './base'

module SfCli
  class Sf
    class Org < Base
      ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status)

      def login_web(target_org: nil, instance_url: nil)
        flags    = {
          :"alias"        => target_org,
          :"instance-url" => instance_url,
        }
        action = __method__.to_s.tr('_', ' ')
        exec(action, flags: flags)
      end

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
