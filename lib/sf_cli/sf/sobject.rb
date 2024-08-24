require_relative './base'

module SfCli
  class Sf
    class Sobject < Base
      def describe(object_type, target_org: nil)
        flags    = {
          :"sobject"    => object_type,
          :"target-org" => target_org,
        }
        json = exec(__method__, flags: flags, redirection: :null_stderr)
        json['result']
      end

      def list(object_type, target_org: nil)
        flags    = {
          :"sobject"    => (object_type.to_sym == :custom ? :custom : :all),
          :"target-org" => target_org,
        }
        json = exec(__method__, flags: flags, redirection: :null_stderr)
        json['result']
      end
    end
  end
end
