module SfCli
  module Sf
    module Model
      module DmlMethods
        def self.included(c)
          c.extend ClassMethods
        end

        def save
          if new_record?
            self.Id = self.class.connection.create(self.class.name.to_sym, current_attributes.reject{|_,v| v.nil?})
          else
            self.class.connection.update(self.class.name.to_sym, self.Id, nil, updated_attributes.reject{|_,v| v.nil?})
          end

          @original_attributes = current_attributes.dup
          @updated_attributes = {}

          self.Id
        end

        def delete
          return if self.Id.nil?

          self.class.connection.delete(self.class.name.to_sym, self.Id)
        end

        module ClassMethods
          def create(values = {})
            connection.create(name.to_sym, values, Object.const_get(name.to_sym))
          end

          def take(id)
            connection.take(name.to_sym, id, Object.const_get(name.to_sym))
          end
        end
      end
    end
  end
end
