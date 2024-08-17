require_relative '../helper_methods'

module SfCli
  class Sf
    class Base
      include ::SfCli::HelperMethods

      attr_reader :target_org

      # *target_org* --- an org alias name, which is used for sf command operations (default is nil). If it is nil, the command uses the default org.
      #
      def initialize(target_org = nil)
        @target_org = target_org
      end
    end
  end
end
