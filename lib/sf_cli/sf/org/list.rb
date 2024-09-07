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
