module SfCli::Sf::Org
  module ListMetadata
    #
    # List the metadata components and properties of a specified type
    # @param metadata    [Symbol,String] name of metadata type
    # @param folder      [Symbol,String] folder associated with the component such as Report, EmailTemplate, Dashboard and Document
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param output_file [String]        pathname of the file in which to write the results
    # @param format      [Symbol,String] output format. json or human is available. (default: json)
    #
    # @return [MetadataList] the list of metadata, which contains its name, its source file path and so on
    #
    # @example
    #  list = sf.org.list_metadata :ApexClass
    #  list.names                        #=> ["CommunitiesLandingController","SiteLoginControllerTest", ...]
    #  list.find :MyProfilePageController #=> <Metadata: full_name="MyProfilePageController" ...>
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_list_metadata_unified command reference
    #
    def list_metadata(metadata, folder: nil, target_org: nil, api_version: nil, output_file: nil, format: :json)
      flags    = {
        :"metadata-type" => metadata,
        :"folder"        => folder,
        :"target-org"    => target_org,
        :"api-version"   => api_version,
        :"output-file"   => output_file,
      }
      action = __method__.to_s.tr('_', ' ')
      output = org_exec(action, flags: flags, redirection: :null_stderr, format: format)
      return output if format.to_sym == :human

      MetadataList.new(output['result'])
    end

    Metadata = Data.define(
      :created_by_id,
      :created_by_name,
      :created_date,
      :file_name,
      :full_name,
      :id,
      :last_modified_by_id,
      :last_modified_by_name,
      :last_modified_date,
      :manageable_state,
      :type) do
        def name
          full_name
        end
      end

    class MetadataList
      include Enumerable

      def initialize(metadata_list)
        @list = metadata_list.map do |m|
          Metadata.new(
            created_by_id:         m['createdById'],
            created_by_name:       m['createdByName'],
            created_date:          m['createdDate'],
            file_name:             m['fileName'],
            full_name:             m['fullName'],
            id:                    m['id'],
            last_modified_by_id:   m['lastModifiedById'],
            last_modified_by_name: m['lastModifiedByName'],
            last_modified_date:    m['lastModifiedDate'],
            manageable_state:      m['manageableState'],
            type:                  m['type']
          )
        end
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
