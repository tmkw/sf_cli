require 'json'
require 'tempfile'

require_relative '../../command_exec_error'

module SfCli
  module Sf
    # @private :nodoc: just for developers
    module Core
      module Base
        private

        def exec(action, flags: {}, switches: {}, redirection: nil, raw_output: false, format: :json) # :doc:
          cmd = %|sf #{category} #{action}#{as_flag_options(flags)}#{as_switch_options(switches, format)}#{redirect redirection}|

          return `#{cmd}` if raw_output

          json = JSON.parse `#{cmd}`
          raise ::SfCli::CommandExecError.new(json['message']) if json['status'] != 0

          json
        end

        def category
          self.class.name.split('::')[-2].downcase
        end

        def field_value_pairs(hash)
          return nil if hash.nil?
          return nil if hash.empty?

          hash.each_with_object([]) do|(k,v), arr|
            value = v.instance_of?(String) ? %|'#{v}'| : v
            arr << %(#{k}=#{value})
          end
          .join(' ')
        end

        def as_flag_options(hash)
          flag_options   = hash.map{|k,v| flag k, v}.reject(&:nil?).join(' ')
          flag_options   = ' ' + flag_options unless flag_options.empty?

          flag_options
        end

        def as_switch_options(hash, format)
          if format.to_sym == :json
            ' ' + {json: true}.merge(hash).each_with_object([]){|(k,v), arr| arr << %(--#{k}) if v}.join(' ')
          else
            return '' if hash.empty?
            hash.each_with_object([]){|(k,v), arr| arr << %(--#{k}) if v}.join(' ')
          end
        end

        def flag(name, arg)
          arg ? %(--#{name} #{arg}) : nil
        end

        def os
          @os ||= ENV['OS']
        end

        def redirect(option)
          case option
          when :null_stderr
            null_stderr_redirection
          else
          end
        end

        def null_stderr_redirection
          @null_stderr_redirection ||=
            if os.eql?('Windows_NT')
              ' 2>nul'
            else
              ' 2> /dev/null'
            end
        end

        def create_tmpfile_by_io(io)
          return nil unless io.respond_to? :read

          Tempfile.open(%w[sf]){|f| f.write(io.read); f}
        end
      end
    end
  end
end
