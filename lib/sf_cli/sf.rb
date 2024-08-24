require 'json'

module SfCli
  class Sf
    OPERATION_CATEGORIES = %w[Org Sobject Data Project]

    # load each operation class and define as a attribute
    OPERATION_CATEGORIES.each do |category|
      require_relative %(sf/#{category.downcase})
      attr_reader category.downcase.to_sym
    end

    attr_reader :varbose

    def initialize
      OPERATION_CATEGORIES.each do |category|
        instance_variable_set(:"@#{category.downcase}", Object.const_get(%|::SfCli::Sf::#{category}|).new(self))
      end
    end

    def exec(category, action, flags: {}, switches: {}, redirection: nil)
      cmd = %|sf #{category} #{action}#{as_flag_options(flags)}#{as_switch_options(switches)}#{redirect redirection}|

      puts cmd if varbose

      json = JSON.parse `#{cmd}`

      puts json if varbose

      raise StandardError.new(json['message']) if json['status'] != 0

      json
    end

    private

    def as_flag_options(hash)
      flag_options   = hash.map{|k,v| flag k, v}.reject(&:nil?).join(' ')
      flag_options   = ' ' + flag_options unless flag_options.empty?

      flag_options
    end

    def as_switch_options(hash)
      ' ' + {json: true}.merge(hash).each_with_object([]){|(k,v), arr| arr << %(--#{k}) if v}.join(' ')
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
