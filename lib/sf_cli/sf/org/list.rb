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
    # @return [OrgConfig] the org configulation
    #
    # @example
    #   org_config_list = sf.org.list        # returns a list of OrgConfig
    #
    #   org_config.first.accesstoken         # returns the access token
    #   org_config.first.instance_url        # returns the org's url
    #
    #   org_config.first.conncected?         # check the connection status
    #   org_config.first.devhub?             # check if the org is devhub or not
    #   org_config.first.scratch?            # check if the org is scratch or not
    #   org_config.first.default?            # check if the org is default or not
    #   org_config.first.default_devhub?     # check if the org is devhub default or not
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_list_unified]
    #
    def list
      flags = {
        # reserved for later option addition
      }
      json = exec(__method__, flags: flags, redirection: :null_stderr)

      others = json['result']['other'].map{|config| OrgConfig.new(**config)}
      sandboxes = json['result']['sandboxes'].map{|config| OrgConfig.new(**config)}
      non_scratch_orgs = json['result']['nonScratchOrgs'].map{|config| OrgConfig.new(**config)}
      devhubs = json['result']['devHubs'].map{|config| OrgConfig.new(**config)}
      scratch_orgs = json['result']['scratchOrgs'].map{|config| OrgConfig.new(**config)}
      
      (others + sandboxes + non_scratch_orgs + devhubs + scratch_orgs).uniq{|config| config.alias}
    end
  end
end
