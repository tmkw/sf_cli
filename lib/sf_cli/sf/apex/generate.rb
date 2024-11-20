module SfCli::Sf::Apex
  module Generate
    # Generate an Apex class
    # @param name        [String,Symbol] Apex class name
    # @param output_dir  [String]        directory for saving the created files
    # @param template    [String,Symbol] template to use for file creation.Permissible values are: ApexException, ApexUnitTest, BasicUnitTest, DefaultApexClass, InboundEmailService
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param raw_output  [Boolian]       output what original command shows
    #
    # @return [Array] the list of files that is created
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm#cli_reference_apex_generate_class_unified command reference
    #
    def generate_class(name, output_dir: nil, template: nil, api_version: nil, raw_output: false)
      flags = {
        :"name" => name,
        :"output-dir" => output_dir,
        :"template" => template,
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

    # Generate an Apex trigger
    # @param name        [String,Symbol] Name of the generated Apex trigger
    # @param output_dir  [String]        directory for saving the created files
    # @param sobject     [String,Symbol] Salesforce object to generate a trigger on
    # @param event       [Array]         Events that fire the trigger.Permissible values are: "before insert", "before update", "before delete", "after insert", "after update", "after delete", "after undelete"
    # @param api_version [Numeric]       override the api version used for api requests made by this command
    # @param raw_output  [Boolian]       output what original command shows
    #
    # @return [Array] the list of files that is created
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_apex_commands_unified.htm#cli_reference_apex_generate_trigger_unified command reference
    #
    def generate_trigger(name, output_dir: nil, sobject: nil, event: nil, api_version: nil, raw_output: false)
      flags = {
        :"name" => name,
        :"output-dir" => output_dir,
        :"sobject" => sobject,
        :"event" => event&.map{|ev| %|"#{ev}"|}&.join(' '),
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
