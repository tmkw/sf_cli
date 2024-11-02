require_relative 'base'

module SfCli::Sf::Core
  module OrgBase
    include Base

    def org_exec(action, flags: {}, switches: {}, redirection: nil, format: :json)
      raw_output = format.to_sym != :json
      exec(action, flags: flags, switches: switches, redirection: redirection, raw_output: raw_output, format: format)
    end
  end
end
