# frozen_string_literal: true

module ActiveModelSerializers
  module Adapter
    class IndexedByID < Base
      def serializable_hash(options = nil)
        options = serialization_options(options)
        serialized_hash = { root => serialized_items(options) }
        self.class.transform_key_casing!(serialized_hash, instance_options)
      end

      private

      def serialized_items(_options)
        arrayfy(serializer).each_with_object({}) do |sr, hash|
          hash[sr.object.id] = sr.attributes.stringify_keys
          sr.associations.each do |assoc|
            isr = {}
            if assoc.serializer.nil?
              arrayfy(assoc.options[:virtual_value]).each do |vv|
                isr[vv['id']] = vv.stringify_keys
              end
            else
              arrayfy(assoc.serializer).each do |asr|
                isr[asr.object.id] = asr.as_json.stringify_keys
              end
            end
            hash[sr.object.id][assoc.name.to_s] = isr
          end
        end
      end

      def arrayfy(stuff)
        stuff.respond_to?(:each) ? stuff : [stuff]
      end
    end
  end
end
