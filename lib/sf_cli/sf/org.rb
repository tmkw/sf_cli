require_relative './base'

module SfCli
  class Sf
    #
    # ==== description
    # The class representing *sf* *org*.
    #
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm
    #
    class Org < Base
      ConnectionInfo = Struct.new(:access_token, :alias, :instance_url, :api_version, :status)

      # login to the org by the browser. It's equivalent to use *sf* *org* *login* *web*
      #
      # *instance_url* --- custom login url.
      #
      def login_web(instance_url: nil)
        `sf org login web #{flag :alias, target_org} #{flag :"instance-url", instance_url}`
      end

      #
      # returns the org's connection information. It's equivalent to use *sf* *org* *display*.
      #
      def display
        lines = StringIO.new(`sf org display #{flag :"target-org", target_org} #{null_stderr_redirection}`).readlines

        connection_info = ConnectionInfo.new(
          access_token: nil,
          alias:        nil,
          instance_url: nil,
          api_version:  nil,
          status:       nil
        )

        lines.each do |line|
          case line
          when /Access Token/
            connection_info.access_token = line.split(' ')[2]
          when /Alias/
            connection_info.alias = line.split(' ')[1]
          when /Instance Url/
            connection_info.instance_url = line.split(' ')[2]
          when /Api Version/
            connection_info.api_version = line.split(' ')[2]
          when /Connected Status/
            connection_info.status = line.split(' ')[2]
          end
        end

        connection_info
      end
    end
  end
end

