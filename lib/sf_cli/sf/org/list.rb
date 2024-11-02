module SfCli::Sf::Org
  module List
    OrgConfig = Struct.new( :accessToken, :instanceUrl, :orgId, :username, :loginUrl,
      :clientId, :isDevHub, :instanceApiVersion, :instanceApiVersionLastRetrieved, :name,
      :instanceName, :namespacePrefix, :isSandbox, :isScratch, :trailExpirationDate, :tracksSource,
      :alias, :isDefaultDevHubUsername, :isDefaultUsername, :lastUsed, :connectedStatus) do
      def devhub?
        isDevHub
      end

      def sandbox?
        isSandbox
      end

      def scratch?
        isScratch
      end

      def default?
        isDefaultUsername
      end

      def default_devhub?
        isDefaultDevHubUsername
      end

      def connected?
        connectedStatus == 'Connected'
      end
    end

    # List orgs you’ve created or authenticated to
    #
    # @note this function returns org information including security sensitive things such as access token, username and so on.
    # @param raw_output  [Boolian] return the original command's output.
    # @return [Array] the org configulations
    #
    # @example
    #   org_configs = sf.org.list        # returns a list of OrgConfig
    #
    #   org_configs.first.accesstoken         # returns the access token
    #   org_configs.first.instance_url        # returns the org's url
    #
    #   org_configs.first.conncected?         # check the connection status
    #   org_configs.first.devhub?             # check if the org is devhub or not
    #   org_configs.first.scratch?            # check if the org is scratch or not
    #   org_configs.first.default?            # check if the org is default or not
    #   org_configs.first.default_devhub?     # check if the org is devhub default or not
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_list_unified command reference
    #
    def list(raw_output: false)
      flags = {
        # reserved for later option addition
      }
      output = org_exec(__method__, flags: flags, redirection: :null_stderr, raw_output: raw_output)

      return output if raw_output

      others = output['result']['other'].map{|config| OrgConfig.new(**config)}
      sandboxes = output['result']['sandboxes'].map{|config| OrgConfig.new(**config)}
      non_scratch_orgs = output['result']['nonScratchOrgs'].map{|config| OrgConfig.new(**config)}
      devhubs = output['result']['devHubs'].map{|config| OrgConfig.new(**config)}
      scratch_orgs = output['result']['scratchOrgs'].map{|config| OrgConfig.new(**config)}
      
      (others + sandboxes + non_scratch_orgs + devhubs + scratch_orgs).uniq{|config| config.alias}
    end
  end
end
