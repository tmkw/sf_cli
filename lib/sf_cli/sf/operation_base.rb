module SfCli
  module Sf
    class OperationBase
      def initialize(_sf)
        @sf  = _sf
      end

      private

      def exec(action, flags: {}, switches: {}, redirection: nil)
        sf.exec(category, action, flags: flags, switches: switches, redirection: redirection)
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

      def sf
        @sf
      end
    end
  end
end
