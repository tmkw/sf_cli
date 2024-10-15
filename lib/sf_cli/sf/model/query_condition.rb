require 'date'

module SfCli
  module Sf
    module Model
      module QueryMethods
        # @private :nodoc: just for developers
        class QueryCondition
          attr_reader :connection,
                      :object_name,
                      :all_field_names,
                      :fields,
                      :conditions,
                      :limit_num,
                      :row_order,
                      :count_select,
                      :max_select_field,
                      :min_select_field

          def initialize(connection, object_name, field_names)
            @object_name = object_name
            @all_field_names = field_names 
            @connection = connection
            @fields = []
            @conditions = [] 
            @limit_num = nil
            @row_order = nil
            @count_select = false
            @max_select_field = nil
            @min_select_field = nil
          end

          def where(*expr)
            return self unless valid_expr?(expr)

            conditions.append to_string_expr(expr)
            self
          end

          def not(*expr)
            return self unless valid_expr?(expr)

            conditions.append %|(NOT(#{to_string_expr(expr)}))|
            self
          end

          def select(*expr)
            return self if expr&.empty?

            if expr.size > 1
              @fields = self.fields + expr
            else
              self.fields << expr.first
            end
            return self
          end

          def limit(num)
            @limit_num = num
            return self
          end

          def order(*fields)
            return self if fields&.empty?

            @row_order = fields
            return self
          end

          def to_soql
            base   = 'SELECT %{select} FROM %{object}' % {select: select_fields, object: object_name}
            where  = conditions.size.zero?  ? nil : 'WHERE %{where}'    % {where: conditions.flatten.join(' AND ')}
            _order = row_order.nil?         ? nil : 'ORDER BY %{order}' % {order: row_order.join(', ')}
            limit  = limit_num.nil?         ? nil : 'LIMIT %{limit}'    % {limit: limit_num} 

            [base, where, _order, limit].compact.join(' ')
          end

          def to_csv
            connection.query(to_soql, Object.const_get(object_name.to_sym), :csv)
          end

          def all
            connection.query(to_soql, Object.const_get(object_name.to_sym))
          end

          def pluck(field_name)
            connection.query(to_soql, nil).map{|record| record[field_name.to_s]}
          end

          def take
            limit(1).all.first
          end

          def count
            @count_select = true
            connection.query(to_soql, nil).first['expr0']
          end

          def max(field_name)
            @max_select_field = field_name
            connection.query(to_soql, nil).first['expr0']
          end

          def min(field_name)
            @min_select_field = field_name
            connection.query(to_soql, nil).first['expr0']
          end

          private

          def select_fields
            return 'COUNT(Id)'                if count_select
            return "MAX(#{max_select_field})" if max_select_field
            return "MIN(#{min_select_field})" if min_select_field

            (fields.empty? ? all_field_names : fields).join(', ')
          end 

          def to_string_expr(expr)
            return str_by_ternary_expr(expr) if expr.size > 1
            return expr[0] if expr[0].instance_of? String

            strs_by_hash_expr(expr)
          end

          def str_by_ternary_expr(expr)
            return self if expr.size < 3

            value = case expr[2].class.name.to_sym
                    when :String
                      %|'#{expr[2]}'|
                    when :Time
                      expr[2].to_datetime
                    when :NilClass
                      :null
                    when :Array
                      candidates = expr[2].map do |o|
                          case o.class.name.to_sym
                          when :String
                            %|'#{o}'|
                          when :Time
                            o.to_datetime
                          when :NilClass
                            :null
                          else
                            o
                          end
                        end
                      %|(#{candidates.join(', ')})|
                    else
                      expr[2]
                    end
            %|#{expr[0]} #{expr[1]} #{value}|
          end

          def valid_expr?(expr)
            return false if expr&.empty?
            return false if expr.map{|o| (o == '' || o == {} || o == []) ? nil : o}.compact.size.zero?
            return false unless [Hash, Symbol, String].any?{|klass| expr.first.instance_of? klass}

            true
          end

          def strs_by_hash_expr(expr)
            expr[0].map do |k,v|
              case v.class.name.to_sym
              when :String
                %|#{k} = '#{v}'|
              when :Time
                %|#{k} = #{v.to_datetime}|
              when :NilClass
                %|#{k} = null|
              when :Array
                candidates = v.map do |o|
                    case o.class.name.to_sym
                    when :String
                      %|'#{o}'|
                    when :Time
                      %|#{o.to_datetime}|
                    when :NilClass
                      :null
                    else
                      o
                    end
                  end
                %|#{k} IN (#{candidates.join(', ')})|
              else
                "#{k} = #{v}"
              end
            end
            .join(' AND ')
          end
        end
      end
    end
  end
end
