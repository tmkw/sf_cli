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
        json = sf.exec(category, __method__, flags: flags, redirection: :null_stderr)
        json['result']
      end

      def list(object_type, target_org: nil)
        flags    = {
          :"sobject"    => (object_type.to_sym == :custom ? :custom : :all),
          :"target-org" => target_org,
        }
        json = sf.exec(category, __method__, flags: flags, redirection: :null_stderr)
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
