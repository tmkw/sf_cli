module SfCli::Sf::Lightning
  module Generate
    # Generate an Apex class
    # @param name        [String,Symbol] component name
    # @param type        [String,Symbol] component type.Only aura or lwc is permissible.
    # @param output_dir  [String]        directory for saving the created files
    # @param template    [String,Symbol] Template to use for file creation.Permissible values are: default, analyticsDashboard, analyticsDashboardWithStep
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param raw_output  [Boolian]       output what original command shows
    #
    # @return [Array] the list of files that is created
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_lightning_commands_unified.htm#cli_reference_lightning_generate_component_unified command reference
    #
    def generate_component(name, type: nil, output_dir: nil, template: nil, api_version: nil, raw_output: false)
      flags = {
        :"name" => name,
        :"output-dir"  => output_dir,
        :"type"        => type,
        :"template"    => template,
        :"api-version" => api_version,
      }
      switches = {
      }
      command_output_format = raw_output ? :human : :json
      redirect_type = raw_output ? nil : :null_stderr
      action = __method__.to_s.tr('_', ' ')
      output = exec(action, flags: flags, switches: switches, redirection: redirect_type, raw_output: raw_output, format: command_output_format)
      return output if raw_output

      output['result']['created']
    end
  end
end
