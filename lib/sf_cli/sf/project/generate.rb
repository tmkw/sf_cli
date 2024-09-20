module SfCli::Sf::Project
  module Generate
    GenerateResult = Struct.new(:output_dir, :files, :raw_output, :warnings)

    #
    # Generate a Salesforce project
    # @param name       [Symbol,String] project name
    # @param template   [Symbol,String] project template name
    # @param output_dir [String]        output directory
    # @param manifest   [Boolian]       switch to create manifest file in the project directory (manifest/package.xml)
    #
    # @return [GenerateResult] the retsult of project generation
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_generate_unified command reference
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
  end
end
