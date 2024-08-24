module SfCli
  class Sf
    class Data
      def initialize(_sf)
        @sf  = _sf
      end

      def query(soql, target_org: nil, model_class: nil)
        flags    = {
          :"query"    => %("#{soql}"),
          :"target-org" => target_org,
        }
        json = sf.exec(category, __method__, flags: flags, redirection: :null_stderr)

        json['result']['records'].each_with_object([]) do |h, a|
          h.delete "attributes"
          a << (model_class ? model_class.new(**h) : h)
        end
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
