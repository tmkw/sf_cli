module SfCli::Sf::Project
  module GenerateManifest
    # Generate the manifest file of a Salesforce DX project
    # @param metadata    [Array]   an array that consists of metadata type like CustomObject, Layout and so on.  (default: [])
    # @param api_version [Integer] API version (default: nil)
    # @param output_dir  [String]  manifest's output directory in the project directory. You can use relative path from the project root (default: nil)
    # @param from_org    [String]  username or alias of the org that contains the metadata components from which to build a manifest (default: nil)
    # @param source_dir  [String]  paths to the local source files to include in the manifest (default: nil)
    #
    # @example
    #  sf.project.generate_manifest metadata: %w[CustomObject Layout] # creates a package.xml, which is initialized with CustomObject and Layout
    #  sf.project.generate_manifest from_org: org_name                # creates a package.xml, which is initialized with all metadata types in the org
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_generate_manifest_unified command reference
    #
    def generate_manifest(name: nil, output_dir: nil, api_version: nil, metadata: [], from_org: nil, source_dir: nil)
      flags    = {
        :name           => name,
        :"metadata"     => (metadata.empty? ? nil : metadata.join(' ')),
        :"from-org"     => from_org,
        :"source-dir"   => source_dir,
        :"output-dir"   => output_dir,
        :"api-version"  => api_version,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      json['result']['path']
    end
  end
end