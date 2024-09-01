require_relative '../core/base'

module SfCli
  module Sf
    module Project
      # ==== description
      # The class representing *sf* *project*
      #
      # command reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base

        GenerateResult = Struct.new(:output_dir, :files, :raw_output, :warnings)

        #
        # generate a Salesforce project. (equivalent to *sf* *project* *generate*)
        #
        # *name*        --- project name<br>
        # *template*    --- project template name<br>
        # *output_dir*  --- output directory<br>
        # *manifest*    --- switch to create manifest file in the project directory (manifest/package.xml). default: false
        #
        # For more command details, see the {reference document}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_generate_unified]
        #
        def generate(name, manifest: false, template: nil, output_dir: nil)
          flags    = {
            :name         => name,
            :template     => template,
            :"output-dir" => output_dir,
          }
          switches = {
            manifest: manifest,
          }
          json = exec(__method__, flags: flags, switches: switches, redirection: :null_stderr)

          GenerateResult.new(
            output_dir: json['result']['outputDir'],
            files:      json['result']['created'],
            raw_output: json['result']['rawOutput'],
            warnings:   json['warnings']
          )
        end

        # generate the manifest file of a Salesforce project. (equivalent to *sf* *project* *generate* *manifest*)
        #
        # *metadata*    --- an array that consists of metadata type like CustomObject, Layout and so on.  (default: [])<br>
        # *api_verson*  --- api version (default: nil)<br>
        # *output_dir*  --- manifest's output directory in the project directory. You can use relative path from the project root (default: nil)<br>
        # *from_org*    --- username or alias of the org that contains the metadata components from which to build a manifest (default: nil)<br>
        # *source_dir*  --- paths to the local source files to include in the manifest (default: nil)
        #
        # == examples
        #  sf.project.generate_manifest metadata: %w[CustomObject Layout]  # creates a package.xml, which is initialized with CustomObject and Layout
        #  sf.project.generate_manifest from_org: <org_name>               # creates a package.xml, which is initialized with all metadata types in the org
        #
        # For more command details, see the {reference document}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_generate_manifest_unified]
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
  end
end
