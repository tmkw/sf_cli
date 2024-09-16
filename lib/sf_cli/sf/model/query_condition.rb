require 'date'

module SfCli
  module Sf
    module Model
      module QueryMethods
        class QueryCondition
          attr_reader :connection, :object_name, :all_field_names, :fields, :conditions, :limit_num, :row_order

          def initialize(connection, object_name, field_names)
            @object_name = object_name
            @all_field_names = field_names 
            @connection = connection
            @fields = []
            @conditions = [] 
            @limit_num = nil
            @row_order = nil
          end

          def where(*expr)
            return self if expr&.empty?
            return self if expr.map{|o| (o == '' || o == {} || o == []) ? nil : o}.compact.size.zero?
            return self unless [Hash, Symbol, String].any?{|klass| expr.first.instance_of? klass}

            if expr.size > 1
              return self if expr.size < 3

              value = case expr[2].class.name.to_sym
                      when :String
                        %|'#{expr[2]}'|
                      when :Time
                        expr[2].to_datetime
                      when :Array
                        candidates = expr[2].map do |o|
                            case o.class.name.to_sym
                            when :String
                              %|'#{o}'|
                            when :Time
                              o.to_datetime
                            else
                              o
                            end
                          end
                        %|(#{candidates.join(', ')})|
                      else
                        expr[2]
                      end
              conditions << %|#{expr[0]} #{expr[1]} #{value}|

              return self
            end

            if expr[0].instance_of? String
              conditions << expr[0]
              return self
            end

            new_conditions =
              expr[0].map do |k,v| 
                case v.class.name.to_sym
                when :String
                  %|#{k} = '#{v}'|
                when :Time
                  %|#{k} = #{v.to_datetime}|
                when :Array
                  candidates = v.map do |o|
                      case o.class.name.to_sym
                      when :String
                        %|'#{o}'|
                      when :Time
                        %|#{o.to_datetime}|
                      else
                        o
                      end
                    end
                  %|#{k} IN (#{candidates.join(', ')})|
                else
                  "#{k} = #{v}"
                end
              end
            conditions.append new_conditions
            return self
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

          def all
            connection.query(to_soql, Object.const_get(object_name.to_sym))
          end

          def pluck(field_name)
            all.map{|record| record.__send__(field_name.to_sym)}
          end

          def take
            all.first
          end

          def select_fields
            (fields.empty? ? all_field_names : fields).join(', ')
          end 
        end
      end
    end
  end
end
