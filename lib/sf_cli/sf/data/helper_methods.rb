module SfCli
  module Sf
    module Data
      # @private
      module HelperMethods
        def prepare_record(hash) # :doc:
          hash.delete 'attributes'

          hash.keys.each do |k|
            if parent?(hash[k])
              hash[k] = prepare_record(hash[k])
            elsif children?(hash[k])
              hash[k] = hash[k]['records'].map{|h| prepare_record(h)}
            end
          end

          hash
        end

        def prepare_record_in_bulk_mode(hash) # :doc:
          hash.keys.each do |k|
            match_result = /(.*)\.(.*)/.match(k)
            if match_result
              hash[match_result[1]] = {match_result[2] => hash[k]}
              hash.delete k
            end
          end

          hash
        end

        def children?(h)
          return false unless h.instance_of?(Hash)

          h.has_key? 'records'
        end

        def parent?(h)
          return false unless h.instance_of?(Hash)

          h.has_key?('records') == false
        end

        private :prepare_record, :children?, :parent?
      end
    end
  end
end
