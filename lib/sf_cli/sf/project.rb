require 'pathname'
require_relative './base'

module SfCli
  class Sf
    # ==== description
    # The class representing *sf* *project*
    #
    # command reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm
    #
    class Project < Base

      #
      # generate a Salesforce project. It's equivalent to *sf* *project* *generate*.
      #
      # *name*        --- project name
      #
      # *template*    --- project template name
      #
      # *output_dir*  --- output directory
      #
      def generate(name, template: 'standard', output_dir: nil)
        `sf project generate #{flag :name, name} #{flag :template, template} #{flag :"output-dir", output_dir} --manifest #{null_stderr_redirection}`
        raise StandardError.new(%|command 'sf project generate' failed.|) unless $?.success?
      end

      # generate the manifest file of a Salesforce project.  It's equivalent to *sf* *project* *generate* *manifest*
      #
      # *metadata*    --- an array that consists of metadata type like CustomObject, Layout and so on.  (default: [])
      # 
      # *api_verson*  --- api version (default: nil)
      # 
      # *project_dir* --- project directory which you want to create the manifest  (default: nil)
      # 
      # *output_dir*  --- manifest's output directory in the project directory. You can use relative path from the project root (default: nil)
      # 
      # *from_org*    --- username or alias of the org that contains the metadata components from which to build a manifest (default: nil)
      # 
      # *source_dir*  --- paths to the local source files to include in the manifest (default: nil)
      #
      # ==== examples
      #   sf.project.generate_manifest metadata: %w[CustomObject Layout]  # creates a package.xml, which is initialized with CustomObject and Layout
      #   sf.project.generate_manifest from_org: <org_name>               # creates a package.xml, which is initialized with all metadata types in the org
      #
      def generate_manifest(metadata: [], api_version: nil, project_dir: nil, output_dir: nil, from_org: nil, source_dir: nil)
        raise StandardError.new('Exactly one of the following must be provided: --from-org, --metadata, --source-dir') if metadata.empty? && from_org.nil? && source_dir.nil?
        base_dir = Dir.pwd

        if project_dir
          raise StandardError.new('the project directory not found') unless FileTest.exist?(project_dir) && FileTest.directory?(project_dir)
          Dir.chdir project_dir
        end

        Dir.mkdir(output_dir) if output_dir && FileTest.exist?(output_dir) == false

        metdata_flags = metadata.empty? ? '' : metadata.map{|md| %|--metadata #{md}|}.join(' ')
        cmd =
          %|sf project generate manifest %{metdata} %{output_dir} %{api_version} %{from_org} %{source_dir}| %
            {
              metdata: metdata_flags,
              output_dir:   flag(:"output-dir", output_dir),
              api_version:  flag(:"api-version", api_version),
              from_org:     flag(:"from-org", from_org),
              source_dir:   flag(:"source-dir", source_dir),
            }
        `#{cmd} #{null_stderr_redirection}`

        raise StandardError.new(%|command 'sf project generate manifest' failed.|) unless $?.success?
      ensure 
        Dir.chdir base_dir
      end
    end
  end
end
