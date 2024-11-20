module SfCli::Sf::Apex
  module Generate
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
