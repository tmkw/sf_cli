require_relative './query_condition'

module SfCli
  module Sf
    module Model
      # @private :nodoc: just for developers
      module QueryMethods
        def self.included(c)
          c.extend ClassMethods
        end

        module ClassMethods
          def where(*expr)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.where(*expr)
            return qc
          end

          def select(*fields)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.select(*fields)
            return qc
          end

          def limit(num)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.limit(num)
            qc
          end

          def order(*field_names)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.order(*field_names)
            qc
          end

          def find(id)
            connection.find(name.to_sym, id, Object.const_get(name.to_sym))
          end

          def find_by(*find_condition)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.where(*find_condition).take
          end

          def all
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.all
          end

          def to_csv
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.to_csv
          end

          def pluck(field_name)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.pluck(field_name)
          end

          def take
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.take
          end

          def count
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.count
          end

          def max(field_name)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.max(field_name)
          end

          def min(field_name)
            qc = QueryCondition.new(connection, self.name, self.field_names)
            qc.min(field_name)
          end
        end
      end
    end
  end
end
