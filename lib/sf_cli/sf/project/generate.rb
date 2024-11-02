module SfCli::Sf::Project
  module Generate
    Result = Struct.new(:output_dir, :files, :raw_output, :warnings)

    #
    # Generate a Salesforce DX project
    # @param name       [Symbol,String] project name
    # @param template   [Symbol,String] project template name
    # @param output_dir [String]        output directory
    # @param manifest   [Boolian]       switch to create manifest file in the project directory (manifest/package.xml)
    # @param raw_output [Boolian]       output what original command shows
    #
    # @return [Result] the retsult of project generation
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_generate_unified command reference
    #
    def generate(name, manifest: false, template: nil, output_dir: nil, raw_output: false)
      flags    = {
        :name         => name,
        :template     => template,
        :"output-dir" => output_dir,
      }
      switches = {
        manifest: manifest,
      }
      command_output_format = raw_output ? :human : :json
      redirect_type = raw_output ? nil : :null_stderr
      output = exec(__method__, flags: flags, switches: switches, redirection: redirect_type, raw_output: raw_output, format: command_output_format)
      return output if raw_output

      Result.new(
        output_dir: output['result']['outputDir'],
        files:      output['result']['created'],
        raw_output: output['result']['rawOutput'],
        warnings:   output['warnings']
      )
    end
  end
end
