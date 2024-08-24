module SfCli
  class Sf
    class Base
      def initialize(_sf)
        @sf  = _sf
      end

      private

      def exec(action, flags: {}, switches: {}, redirection: nil)
        sf.exec(category, action, flags: flags, switches: switches, redirection: redirection)
      end

      def category
        self.class.name.split('::').last.downcase
      end

      def sf
        @sf
      end
    end
  end
end
