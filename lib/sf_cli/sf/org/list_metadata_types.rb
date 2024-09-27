module SfCli::Sf::Org
  module ListMetadataTypes
    #
    # Returns the metadata types that are enabled for your org.
    # @param target_org  [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param output_file [String]        pathname of the file in which to write the results
    #
    # @return [Result] the command's output
    #
    # @example
    #  result = sf.org.list_metadata_types target_org: :dev
    #  result.metadata_objects.names #=> ["InstalledPackage","CustomLabels", ...]
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm#cli_reference_org_list_metadata-types_unified
    #
    def list_metadata_types(target_org: nil, api_version: nil, output_file: nil)
      flags    = {
        :"target-org" => target_org,
        :"api-version" => api_version,
        :"output-file" => output_file,
      }
      action = __method__.to_s.tr('_', '-').sub('-', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      Result.new(
        metadata_objects:       MetadataObjects.new(json['result']['metadataObjects']),
        organization_namespace: json['result']['organizationNamespace'],
        partial_save_allowed:   json['result']['partialSaveAllowed'],
        test_required:          json['result']['testRequired']
      )
    end

    MetadataObject = Data.define(:directory_name, :in_folder, :meta_file, :suffix, :xml_name, :child_xml_names) do
        def name
          xml_name
        end

        def in_folder?
          in_folder
        end

        def meta_file?
          meta_file
        end
      end

    Result = Data.define(:metadata_objects, :organization_namespace, :partial_save_allowed, :test_required)

    class MetadataObjects
      include Enumerable

      def initialize(metadata_objects)
        @metadata_objects = metadata_objects.map do |mo|
          MetadataObject.new(
            directory_name:  mo['directoryName'],
            in_folder:       mo['inFolder'],
            meta_file:       mo['metaFile'],
            suffix:          mo['suffix'],
            xml_name:        mo['xmlName'],
            child_xml_names: mo['childXmlNames']
          )
        end
      end

      def each(&block)
        metadata_objects.each(&block)
      end

      def names
        metadata_objects.map(&:name)
      end

      def find(name)
        metadata_objects.find{|mo| mo.name == name.to_s}
      end

      private

      def metadata_objects
        @metadata_objects
      end
    end
  end
end
