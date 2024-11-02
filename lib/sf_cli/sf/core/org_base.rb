require_relative 'base'

module SfCli::Sf::Core
  module OrgBase
    include Base

    def org_exec(action, flags: {}, switches: {}, redirection: nil, raw_output: false)
      fmt = raw_output ? :human : :json
      redirect_type = raw_output ? nil : :null_stderr
      exec(action, flags: flags, switches: switches, redirection: redirect_type, raw_output: raw_output, format: fmt)
    end
  end
end
