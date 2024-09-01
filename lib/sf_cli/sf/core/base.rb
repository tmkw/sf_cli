module SfCli
  module Sf
    module Core
      module Base
        attr_reader :varbose

        private

        def exec(action, flags: {}, switches: {}, redirection: nil, raw_output: false, format: :json)
          cmd = %|sf #{category} #{action}#{as_flag_options(flags)}#{as_switch_options(switches, format)}#{redirect redirection}|
          puts cmd if varbose

          return `#{cmd}` if raw_output

          json = JSON.parse `#{cmd}`
          puts json if varbose
          raise StandardError.new(json['message']) if json['status'] != 0

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
      end
    end
  end
end
