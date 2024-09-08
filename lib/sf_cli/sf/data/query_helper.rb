require_relative './helper_methods'

module SfCli::Sf::Data
  module Query
    class RegularResultAdjuster # :nodoc: all
      include ::SfCli::Sf::Data::HelperMethods

      attr_reader :result, :model_class

      def initialize(result, model_class)
        @result = result
        @model_class = model_class
      end

      def get_return_value
        result['result']['records'].each_with_object([]) do |h, a|
          record = prepare_record(h)
          a << (model_class ? model_class.new(**record) : record)
        end
      end
    end

    class BulkResultAdjuster # :nodoc: all
      include ::SfCli::Sf::Data::HelperMethods

      attr_reader :result, :model_class

      def initialize(result, model_class)
        @result = result
        @model_class = model_class
      end

      def get_return_value
        done = result['result']['done']
        id   = result['result']['id']
        rows = result['result']['records'].each_with_object([]) do |h, a|
            record = prepare_record_in_bulk_mode(h)
            a << (model_class ? model_class.new(**record) : record)
          end

        done ? [done, rows] : [done, id]
      end
    end

    class RawOutputResultAdjuster # :nodoc: all
      attr_reader :result

      def initialize(result)
        @result = result
      end

      def get_return_value
        result
      end
    end
  end
end
