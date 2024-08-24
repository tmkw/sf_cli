module SfCli
  class Sf
    class Org
      ConnectionInfo = Struct.new(:id, :access_token, :alias, :instance_url, :user_name, :api_version, :status)

      def initialize(_sf)
        @sf  = _sf
      end

      def login_web(target_org: nil, instance_url: nil)
        flags    = {
          :"alias"        => target_org,
          :"instance-url" => instance_url,
        }
        action = __method__.to_s.tr('_', ' ')
        sf.exec(category, action, flags: flags)
      end

      def display(target_org: nil)
        flags    = {:"target-org" => target_org}
        json = sf.exec(category, __method__, flags: flags, redirection: :null_stderr)
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

      private

      def category
        self.class.name.split('::').last.downcase
      end

      def sf
        @sf
      end
    end
  end
end
