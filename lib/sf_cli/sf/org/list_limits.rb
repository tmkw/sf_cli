module SfCli::Sf::Org
  module ListLimits
    #
    # Returns the metadata types that are enabled for your org.
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    #
    # @return [Limits] the list of limit information
    #
    # @example
    #  limits = sf.org.list_limits
    #  limits.names                   #=> ["ActiveScratchOrgs","AnalyticsExternalDataSizeMB", ...]
    #  limits.find :ActiveScratchOrgs #=> <Limit: name="ActiveScratchOrgs", remaining=3, max=3>
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_list_limits_unified command reference
    #
    def list_limits(target_org: nil, api_version: nil)
      flags    = {
        :"target-org"    => target_org,
        :"api-version"   => api_version,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      Limits.new(json['result'])
    end

    Limit = Data.define(:name, :remaining, :max)

    class Limits
      include Enumerable

      def initialize(list)
        @list = list.map {|limit| Limit.new(**limit)}
      end

      def each(&block)
        list.each(&block)
      end

      def names
        list.map(&:name)
      end

      def find(name)
        list.find{|m| m.name == name.to_s}
      end

      private

      def list
        @list
      end
    end
  end
end