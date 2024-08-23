require 'json'
require_relative 'sf/org'

module SfCli
  class Sf
    class Sobject
      def initialize(_sf)
        @sf  = _sf
      end

      def describe(object_type, target_org: nil)
        flags    = {
          :"sobject"    => object_type,
          :"target-org" => target_org,
        }
        switches = [:json]
        json = sf.exec(category, __method__, flags: flags, switches: switches, redirection: :null_stderr)
        json['result']
      end

      def list(object_type, target_org: nil)
        flags    = {
          :"sobject"    => (object_type.to_sym == :custom ? :custom : :all),
          :"target-org" => target_org,
        }
        switches = [:json]
        json = sf.exec(category, __method__, flags: flags, switches: switches, redirection: :null_stderr)
        json['result']
      end

      private

      def category
        self.class.name.split('::').last.downcase
      end

      def sf
        @sf
      end
    end
  end
end

module SfCli
  class Sf
    CATEGORIES = %w[Org Sobject].tap do |categories|
      categories.each do |category|
        attr_reader category.downcase.to_sym
      end
    end

    attr_reader :varbose

    def initialize
      CATEGORIES.each do |category|
        instance_variable_set(:"@#{category.downcase}", Object.const_get(%|::SfCli::Sf::#{category}|).new(self))
      end
    end

    def exec(category, action, flags: {}, switches: [], redirection: nil)
      flag_options   = flags.map{|k,v| flag k, v}.reject(&:nil?).join(' ')
      flag_options   = ' ' + flag_options unless flag_options.empty?
      switch_options = switches.empty? ? '' : ' ' + switches.map{|s| %(--#{s})}.join(' ')

      cmd = %|sf #{category} #{action}#{flag_options}#{switch_options}#{redirect redirection}|

      puts cmd if varbose

      json = JSON.parse `#{cmd}`

      puts json if varbose

      raise StandardError.new(json['message']) if json['status'] != 0

      json
    end

    private

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
