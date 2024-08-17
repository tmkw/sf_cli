module SfCli
  module HelperMethods
    def os
      @os ||= ENV['OS']
    end

    def null_stderr_redirection
      @null_stderr_redirection ||=
        if os.nil? || os.eql?('Windows_NT')
          '2>nul'
        else
          '2> dev/null'
        end
    end

    def flag(name, arg = nil, use_argument: true, long_flag: true)
      flag_indicator = long_flag ? '--' : '-'

      if use_argument
        arg ? %(#{flag_indicator}#{name} #{arg}) : ''
      else
        %(#{flag_indicator}#{name})
      end
    end
  end
end